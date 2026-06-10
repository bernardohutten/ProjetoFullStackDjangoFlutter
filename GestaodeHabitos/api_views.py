from datetime import date

from django.shortcuts import get_object_or_404
from django.db import IntegrityError
from django.contrib.auth.models import User

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from .models import (
    Atividades,
    Registro,
    TipoAtividade,
    Avaliacao,
    Questao,
    Alternativa,
    RespostaUsuario
)

from .serializers import (
    AtividadesSerializer,
    RegistroSerializer,
    AvaliacaoSerializer,
    AvaliacaoDetalheSerializer
)


def garantir_atividades_padrao(usuario):
    tipos_padrao = [
        "Quiz",
        "Estudar",
        "Fazer Prova"
    ]

    for nome in tipos_padrao:
        tipo, created = TipoAtividade.objects.get_or_create(
            nome=nome
        )

        Atividades.objects.get_or_create(
            usuario=usuario,
            nome_atividade=nome,
            defaults={
                'tipo': tipo
            }
        )


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def minhas_atividades(request):
    garantir_atividades_padrao(request.user)

    atividades = Atividades.objects.filter(
        usuario=request.user
    ).order_by('-data_criacao')

    serializer = AtividadesSerializer(
        atividades,
        many=True
    )

    return Response(
        serializer.data
    )


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def criar_atividade_api(request):
    nome_atividade = request.data.get('nome_atividade')

    if not nome_atividade:
        return Response(
            {
                'erro': 'O nome da atividade é obrigatório.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    nome_atividade = nome_atividade.strip().title()

    if not nome_atividade:
        return Response(
            {
                'erro': 'O nome da atividade não pode estar vazio.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    nomes_padrao = [
        'Quiz',
        'Estudar',
        'Fazer Prova'
    ]

    if nome_atividade in nomes_padrao:
        return Response(
            {
                'erro': 'Essa atividade já existe como padrão.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        atividade = Atividades.objects.create(
            usuario=request.user,
            nome_atividade=nome_atividade
        )

    except IntegrityError:
        return Response(
            {
                'erro': 'Você já possui uma atividade com esse nome.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    serializer = AtividadesSerializer(
        atividade
    )

    return Response(
        serializer.data,
        status=status.HTTP_201_CREATED
    )


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def registrar_atividade_api(request, atividade_id):
    atividade = get_object_or_404(
        Atividades,
        id=atividade_id,
        usuario=request.user
    )

    hoje = date.today()

    ja_registrado = Registro.objects.filter(
        atividade=atividade,
        data=hoje
    ).exists()

    if ja_registrado:
        return Response(
            {
                'erro': 'Você já registrou esta atividade hoje.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    registro = Registro.objects.create(
        atividade=atividade,
        data=hoje
    )

    serializer = RegistroSerializer(
        registro
    )

    return Response(
        serializer.data,
        status=status.HTTP_201_CREATED
    )


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def deletar_atividade_api(request, atividade_id):
    atividade = get_object_or_404(
        Atividades,
        id=atividade_id,
        usuario=request.user
    )

    if atividade.tipo is not None:
        return Response(
            {
                'erro': 'Essa atividade padrão não pode ser excluída.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    atividade.delete()

    return Response(
        {
            'mensagem': 'Atividade deletada com sucesso.'
        },
        status=status.HTTP_200_OK
    )


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listar_avaliacoes_api(request):
    avaliacoes = Avaliacao.objects.all().order_by('-data_criacao')

    serializer = AvaliacaoSerializer(
        avaliacoes,
        many=True
    )

    return Response(
        serializer.data
    )


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def detalhe_avaliacao_api(request, avaliacao_id):
    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id
    )

    serializer = AvaliacaoDetalheSerializer(
        avaliacao
    )

    return Response(
        serializer.data
    )


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def responder_avaliacao_api(request, avaliacao_id):
    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id
    )

    respostas = request.data.get('respostas', [])

    if not respostas:
        return Response(
            {
                'erro': 'Nenhuma resposta foi enviada.'
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    respostas_salvas = 0

    for resposta in respostas:
        questao_id = resposta.get('questao_id')

        if not questao_id:
            continue

        questao = Questao.objects.filter(
            id=questao_id,
            avaliacao=avaliacao
        ).first()

        if not questao:
            continue

        if questao.tipo == 'multipla':
            alternativa_id = resposta.get('alternativa_id')

            alternativa = Alternativa.objects.filter(
                id=alternativa_id,
                questao=questao
            ).first()

            if alternativa:
                RespostaUsuario.objects.update_or_create(
                    usuario=request.user,
                    questao=questao,
                    defaults={
                        'alternativa': alternativa,
                        'resposta_texto': None
                    }
                )

                respostas_salvas += 1

        elif questao.tipo == 'aberta':
            resposta_texto = resposta.get('resposta_texto', '')
            resposta_texto = resposta_texto.strip()

            if resposta_texto:
                RespostaUsuario.objects.update_or_create(
                    usuario=request.user,
                    questao=questao,
                    defaults={
                        'alternativa': None,
                        'resposta_texto': resposta_texto
                    }
                )

                respostas_salvas += 1

    return Response(
        {
            'mensagem': 'Respostas enviadas com sucesso.',
            'respostas_salvas': respostas_salvas
        },
        status=status.HTTP_200_OK
    )

@api_view(['POST'])
@permission_classes([])
def cadastrar_usuario_api(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if not username or not email or not password:
        return Response(
            {'erro': 'Preencha todos os campos.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    if User.objects.filter(username=username).exists():
        return Response(
            {'erro': 'Esse usuário já existe.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    if User.objects.filter(email=email).exists():
        return Response(
            {'erro': 'Esse email já está cadastrado.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    User.objects.create_user(
        username=username,
        email=email,
        password=password
    )

    return Response(
        {'mensagem': 'Usuário criado com sucesso.'},
        status=status.HTTP_201_CREATED
    )

from .models import Atividades, Registro


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def me_api(request):

    total_atividades = Atividades.objects.filter(
        usuario=request.user
    ).count()

    total_registros = Registro.objects.filter(
        atividade__usuario=request.user
    ).count()

    return Response({
        'id': request.user.id,
        'username': request.user.username,
        'email': request.user.email,
        'total_atividades': total_atividades,
        'total_registros': total_registros,
    })
from .models import Conteudo
from .serializers import ConteudoSerializer


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listar_conteudos_api(request):

    conteudos = Conteudo.objects.all().order_by(
        '-criado_em'
    )

    serializer = ConteudoSerializer(
        conteudos,
        many=True
    )

    return Response(serializer.data)