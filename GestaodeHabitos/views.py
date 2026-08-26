# ==========================================
# IMPORTAÇÕES BÁSICAS DO DJANGO
# ==========================================

from django.shortcuts import render, redirect, get_object_or_404
from django.utils import timezone
# render → carrega uma página HTML
# redirect → redireciona para outra rota
# get_object_or_404 → busca um objeto no banco; se não achar, retorna erro 404


# ==========================================
# IMPORTAÇÃO DOS MODELS DO SEU APP
# ==========================================

from .models import (
    Atividades,
    Registro,
    TipoAtividade,
    Avaliacao,
    Questao,
    Alternativa,
    RespostaUsuario,
    Tentativa,
    
)

# Atividades → atividades do usuário
# Registro → registros diários das atividades
# TipoAtividade → atividades padrão, como Quiz, Estudar e Fazer Prova
# Avaliacao → representa um Quiz ou uma Prova
# Questao → perguntas da avaliação
# Alternativa → opções de múltipla escolha
# RespostaUsuario → resposta enviada pelo usuário


# ==========================================
# AUTENTICAÇÃO
# ==========================================

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required

# authenticate → verifica username e senha
# login → inicia sessão do usuário
# logout → encerra sessão
# User → model padrão de usuário do Django
# login_required → bloqueia acesso de quem não está logado


# ==========================================
# OUTRAS IMPORTAÇÕES
# ==========================================

from datetime import date
from django.views.decorators.http import require_POST
from django.contrib import messages
from django.db import IntegrityError

# date → usado para pegar a data atual
# require_POST → força uma view a aceitar apenas requisições POST
# messages → sistema de mensagens do Django
# IntegrityError → captura erro de banco, como duplicidade


# ==========================================
# VIEW DE LOGIN
# ==========================================

def login_usuario(request):

    # Se o formulário foi enviado
    if request.method == 'POST':

        # Pega os dados enviados pelo formulário
        username = request.POST.get('username')
        password = request.POST.get('password')

        # Tenta autenticar o usuário
        user = authenticate(
            request,
            username=username,
            password=password
        )

        # Se o usuário existir e a senha estiver correta
        if user is not None:

            # Cria a sessão do usuário
            login(request, user)

            # Redireciona para a home
            return redirect('home')

        # Se username ou senha estiverem errados
        else:
            messages.error(
                request,
                "Usuário ou senha inválidos."
            )

    # Se for GET, apenas mostra a página de login
    return render(
        request,
        'login_usuario.html'
    )


# ==========================================
# VIEW DE CADASTRO
# ==========================================

def cadastrar_usuario(request):

    # Se o formulário foi enviado
    if request.method == 'POST':

        # Pega os dados enviados
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')

        # Evita erro caso algum campo venha como None
        if not username or not email or not password:
            messages.error(
                request,
                "Preencha todos os campos."
            )
            return redirect('cadastrar_usuario')

        # Normaliza os dados
        # strip remove espaços antes/depois
        # lower deixa o email em minúsculo
        username = username.strip()
        email = email.strip().lower()

        # Impede username vazio depois do strip
        if not username:
            messages.error(
                request,
                "O nome de usuário não pode estar vazio."
            )
            return redirect('cadastrar_usuario')

        # Impede email vazio depois do strip
        if not email:
            messages.error(
                request,
                "O email não pode estar vazio."
            )
            return redirect('cadastrar_usuario')

        # Verifica se já existe usuário com esse username
        if User.objects.filter(username=username).exists():
            messages.error(
                request,
                "Esse nome de usuário já existe."
            )
            return redirect('cadastrar_usuario')

        # Verifica se já existe usuário com esse email
        if User.objects.filter(email=email).exists():
            messages.error(
                request,
                "Esse email já está cadastrado."
            )
            return redirect('cadastrar_usuario')

        # Cria o usuário usando create_user
        # create_user já criptografa a senha corretamente
        User.objects.create_user(
            username=username,
            email=email,
            password=password,
        )

        messages.success(
            request,
            "Usuário criado com sucesso!"
        )

        return redirect('login_usuario')

    # Se for GET, mostra a página de cadastro
    return render(
        request,
        'cadastrar_usuario.html'
    )


# ==========================================
# FUNÇÃO AUXILIAR: CRIAR ATIVIDADES PADRÃO
# ==========================================

def garantir_atividades_padrao(usuario):

    # Lista de atividades padrão que todo usuário deve ter
    tipos_padrao = [
        "Quiz",
        "Estudar",
        "Fazer Prova"
    ]

    # Para cada nome da lista
    for nome in tipos_padrao:

        # Garante que existe um TipoAtividade global no banco
        tipo, created = TipoAtividade.objects.get_or_create(
            nome=nome
        )

        # Garante que o usuário tenha uma atividade ligada a esse tipo
        Atividades.objects.get_or_create(
            usuario=usuario,
            nome_atividade=nome,
            defaults={
                'tipo': tipo
            }
        )


# ==========================================
# HOME
# ==========================================

@login_required
def home(request):

    # Antes de carregar a home, garante que o usuário tenha:
    # Quiz, Estudar e Fazer Prova
    garantir_atividades_padrao(request.user)

    # Busca todas as atividades daquele usuário
    atividades = Atividades.objects.filter(
        usuario=request.user
    ).order_by('-data_criacao')

    # Mostra a home com as atividades
    return render(
        request,
        'home.html',
        {
            'atividades': atividades
        }
    )


# ==========================================
# CRIAR ATIVIDADE PERSONALIZADA
# ==========================================

@require_POST
@login_required
def criar_atividade(request):

    # Pega o nome enviado pelo modal/formulário
    nome_atividade = request.POST.get('nome_atividade')

    # Se não veio nome nenhum
    if not nome_atividade:
        messages.error(
            request,
            "O nome da atividade não pode estar vazio."
        )
        return redirect('home')

    # Remove espaços e padroniza o nome
    nome_atividade = nome_atividade.strip().title()

    # Se depois do strip ficou vazio
    if not nome_atividade:
        messages.error(
            request,
            "O nome da atividade não pode estar vazio."
        )
        return redirect('home')

    # Impede o usuário de criar manualmente nomes reservados
    nomes_padrao = [
        'Quiz',
        'Estudar',
        'Fazer Prova'
    ]

    if nome_atividade in nomes_padrao:
        messages.error(
            request,
            "Essa atividade já existe como padrão."
        )
        return redirect('home')

    try:
        # Cria a atividade personalizada do usuário
        # Como tipo não foi passado, tipo fica NULL
        Atividades.objects.create(
            usuario=request.user,
            nome_atividade=nome_atividade
        )

        messages.success(
            request,
            "Atividade criada com sucesso!"
        )

    except IntegrityError:
        # Captura duplicidade protegida pelo unique_together
        messages.error(
            request,
            "Você já possui uma atividade com esse nome."
        )

    return redirect('home')


# ==========================================
# REGISTRAR ATIVIDADE UMA VEZ POR DIA
# ==========================================

@require_POST
@login_required
def registrar_atividade(request, atividade_id):

    # Busca a atividade pelo id
    # Mas só permite se ela pertencer ao usuário logado
    atividade = get_object_or_404(
        Atividades,
        id=atividade_id,
        usuario=request.user
    )

    # Data de hoje
    hoje = date.today()

    # Verifica se já existe registro dessa atividade hoje
    ja_registrado = Registro.objects.filter(
        atividade=atividade,
        data=hoje
    ).exists()

    # Se já registrou hoje, não cria outro
    if ja_registrado:
        messages.warning(
            request,
            "Você já registrou esta atividade hoje."
        )

    # Se ainda não registrou, cria um novo registro
    else:
        Registro.objects.create(
            atividade=atividade,
            data=hoje
        )

        messages.success(
            request,
            "Atividade registrada com sucesso!"
        )

    return redirect('home')


# ==========================================
# DELETAR ATIVIDADE PERSONALIZADA
# ==========================================

@require_POST
@login_required
def deletar_atividade(request, id):

    # Busca atividade do usuário
    atividade = get_object_or_404(
        Atividades,
        id=id,
        usuario=request.user
    )

    # Se a atividade possui tipo, ela é padrão
    # Exemplo: Quiz, Estudar, Fazer Prova
    if atividade.tipo is not None:
        messages.error(
            request,
            "Essa atividade padrão não pode ser excluída."
        )
        return redirect('home')

    # Se não for padrão, pode deletar
    atividade.delete()

    messages.success(
        request,
        "Atividade deletada com sucesso."
    )

    return redirect('home')


# ==========================================
# LOGOUT
# ==========================================

@login_required
@require_POST
def logout_usuario(request):

    # Encerra a sessão
    logout(request)

    messages.success(
        request,
        "Logout realizado com sucesso."
    )

    return redirect('login_usuario')


# ==========================================
# PÁGINA ESTUDAR
# ==========================================

@login_required
def estudar(request):

    # Página simples por enquanto
    # Futuramente pode mostrar textos, materiais e progresso
    return render(
        request,
        'atividades/estudar.html'
    )


# ==========================================
# LISTAR QUIZZES
# ==========================================

@login_required
def listar_quizzes(request):

    # Busca todas as avaliações do tipo quiz
    quizzes = Avaliacao.objects.filter(
        tipo='quiz'
    ).order_by('-data_criacao')

    return render(
        request,
        'atividades/listar_quizzes.html',
        {
            'quizzes': quizzes
        }
    )


# ==========================================
# LISTAR PROVAS
# ==========================================

@login_required
def listar_provas(request):

    # Busca todas as avaliações do tipo prova
    provas = Avaliacao.objects.filter(
        tipo='prova'
    ).order_by('-data_criacao')

    return render(
        request,
        'atividades/listar_provas.html',
        {
            'provas': provas
        }
    )


# ==========================================
# CRIAR AVALIAÇÃO
# ==========================================

@login_required
def criar_avaliacao(request):

    # Essa view serve para criar tanto quiz quanto prova

    if request.method == 'POST':

        titulo = request.POST.get('titulo')
        tipo = request.POST.get('tipo')
        tentativas_permitidas = request.POST.get('tentativas_permitidas')
        # Validação básica
       
          

        if not titulo or not tipo:
            messages.error(
                request,
                "Preencha o título e o tipo da avaliação."
            )
            return redirect('criar_avaliacao')

        titulo = titulo.strip()

        if not titulo:
            messages.error(
                request,
                "O título não pode estar vazio."
            )
            return redirect('criar_avaliacao')

        # Garante que só aceite quiz ou prova
        if tipo not in ['quiz', 'prova']:
            messages.error(
                request,
                "Tipo de avaliação inválido."
            )
            return redirect('criar_avaliacao')

        if tipo == 'prova':

            if not tentativas_permitidas:
                messages.error(
                    request, 'informe o número de tentativas permitidas'
                )
                return redirect(criar_avaliacao)

            try:
                tentativas_permitidas = int(
                    tentativas_permitidas
                )
            except ValueError:
                messages.error(
                    request, "O numero de tentativas deve ser um número inteiro"
                )
                return redirect(criar_avaliacao)

            if tentativas_permitidas <=0:
                messages.error(
                    request,
                    "o numero de tentativas deve ser maio que zero"
                )
                return redirect(criar_avaliacao)
        else:
            tentativas_permitidas = None

        # Cria a avaliação
        avaliacao = Avaliacao.objects.create(
            titulo=titulo,
            tipo=tipo,
            professor=request.user,
            tentativas_permitidas = tentativas_permitidas
        )

        messages.success(
            request,
            "Avaliação criada com sucesso. Agora adicione questões."
        )

        # Depois de criar, manda para a tela de criar questão
        return redirect(
            'criar_questao',
            avaliacao_id=avaliacao.id
        )

    return render(
        request,
        'atividades/criar_avaliacao.html'
    )


# ==========================================
# CRIAR QUESTÃO
# ==========================================

@login_required
def criar_questao(request, avaliacao_id):

    # Busca a avaliação
    # Só o professor dono pode adicionar questões
    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id,
        professor=request.user
    )

    if request.method == 'POST':

        enunciado = request.POST.get('enunciado')
        tipo = request.POST.get('tipo')

        # Validação básica
        if not enunciado or not tipo:
            messages.error(
                request,
                "Preencha o enunciado e o tipo da questão."
            )
            return redirect(
                'criar_questao',
                avaliacao_id=avaliacao.id
            )

        enunciado = enunciado.strip()

        if not enunciado:
            messages.error(
                request,
                "O enunciado não pode estar vazio."
            )
            return redirect(
                'criar_questao',
                avaliacao_id=avaliacao.id
            )

        # Valida o tipo da questão
        if tipo not in ['multipla', 'aberta']:
            messages.error(
                request,
                "Tipo de questão inválido."
            )
            return redirect(
                'criar_questao',
                avaliacao_id=avaliacao.id
            )

        # Regra importante:
        # Quiz deve ter apenas questões de múltipla escolha
        if avaliacao.tipo == 'quiz' and tipo == 'aberta':
            messages.error(
                request,
                "Quiz não pode ter questão aberta. Use múltipla escolha."
            )
            return redirect(
                'criar_questao',
                avaliacao_id=avaliacao.id
            )

        # Cria a questão
        questao = Questao.objects.create(
            avaliacao=avaliacao,
            enunciado=enunciado,
            tipo=tipo
        )

        messages.success(
            request,
            "Questão criada com sucesso."
        )

        # Se for questão múltipla, manda para criar alternativas
        if tipo == 'multipla':
            return redirect(
                'criar_alternativas',
                questao_id=questao.id
            )

        # Se for questão aberta, volta para criar mais questões
        return redirect(
            'criar_questao',
            avaliacao_id=avaliacao.id
        )

    # Busca questões já criadas para mostrar na tela
    questoes = Questao.objects.filter(
        avaliacao=avaliacao
    )

    return render(
        request,
        'atividades/criar_questao.html',
        {
            'avaliacao': avaliacao,
            'questoes': questoes
        }
    )


# ==========================================
# CRIAR ALTERNATIVAS
# ==========================================

@login_required
def criar_alternativas(request, questao_id):

    # Busca a questão
    # Só permite editar se o professor dono da avaliação for o usuário logado
    questao = get_object_or_404(
        Questao,
        id=questao_id,
        avaliacao__professor=request.user
    )

    # Se a questão não for múltipla escolha, não faz sentido criar alternativa
    if questao.tipo != 'multipla':
        messages.error(
            request,
            "Apenas questões de múltipla escolha possuem alternativas."
        )
        return redirect(
            'criar_questao',
            avaliacao_id=questao.avaliacao.id
        )

    if request.method == 'POST':

        texto = request.POST.get('texto')
        correta = request.POST.get('correta')

        # Validação básica do texto
        if not texto:
            messages.error(
                request,
                "O texto da alternativa não pode estar vazio."
            )
            return redirect(
                'criar_alternativas',
                questao_id=questao.id
            )

        texto = texto.strip()

        if not texto:
            messages.error(
                request,
                "O texto da alternativa não pode estar vazio."
            )
            return redirect(
                'criar_alternativas',
                questao_id=questao.id
            )

        # Checkbox HTML geralmente envia "on" quando marcado
        alternativa_correta = correta == 'on'

        # Cria a alternativa
        Alternativa.objects.create(
            questao=questao,
            texto=texto,
            correta=alternativa_correta
        )

        messages.success(
            request,
            "Alternativa adicionada com sucesso."
        )

        return redirect(
            'criar_alternativas',
            questao_id=questao.id
        )

    # Busca alternativas já cadastradas para essa questão
    alternativas = Alternativa.objects.filter(
        questao=questao
    )

    return render(
        request,
        'atividades/criar_alternativas.html',
        {
            'questao': questao,
            'alternativas': alternativas
        }
    )


# ==========================================
# ABRIR QUIZ PARA RESPONDER
# ==========================================

@login_required
def quiz(request, avaliacao_id):

    # Busca uma avaliação do tipo quiz
    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id,
        tipo='quiz'
    )

    # Busca as questões do quiz
    questoes = Questao.objects.filter(
        avaliacao=avaliacao
    )

    return render(
        request,
        'atividades/quiz.html',
        {
            'avaliacao': avaliacao,
            'questoes': questoes
        }
    )



# ==========================================
# ABRIR PROVA PARA RESPONDER
# ==========================================

@login_required
def prova(request, avaliacao_id):

    # ------------------------------------------
    # Busca a avaliação.
    #
    # O tipo precisa obrigatoriamente ser prova.
    # ------------------------------------------

    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id,
        tipo='prova'
    )

    # ------------------------------------------
    # Conta quantas tentativas o usuário
    # já realizou nessa prova.
    # ------------------------------------------

    quantidade_tentativas = Tentativa.objects.filter(
        usuario=request.user,
        avaliacao=avaliacao,
  
    ).count()

    # ------------------------------------------
    # Verifica se o usuário já atingiu o limite.
    #
    # Exemplo:
    #
    # permitidas = 3
    # realizadas = 3
    #
    # 3 >= 3
    # → não pode fazer outra.
    # ------------------------------------------

    if quantidade_tentativas >= avaliacao.tentativas_permitidas:

        messages.error(
            request,
            "Você atingiu o limite de tentativas desta prova."
        )

        return redirect('listar_provas')

    # ------------------------------------------
    # Busca as questões da prova.
    # ------------------------------------------

    questoes = Questao.objects.filter(
        avaliacao=avaliacao
    )

    # ------------------------------------------
    # NÃO criamos a tentativa aqui.
    #
    # Vamos criar somente quando o usuário
    # realmente iniciar a prova.
    # ------------------------------------------

    return render(
        request,
        'atividades/prova.html',
        {
            'avaliacao': avaliacao,
            'questoes': questoes,
            'tentativas_realizadas': quantidade_tentativas
        }
    )

# ==========================================
# ENVIAR RESPOSTAS DE UMA AVALIAÇÃO
# ==========================================

@require_POST
@login_required
def responder_avaliacao(
    request,
    avaliacao_id,
    tentativa_id
):

    # ------------------------------------------
    # Busca a avaliação
    # ------------------------------------------

    avaliacao = get_object_or_404(
        Avaliacao,
        id=avaliacao_id
    )

    # ------------------------------------------
    # Busca a tentativa.
    #
    # Além do ID, verificamos:
    #
    # usuario=request.user
    #
    # Isso impede que um usuário envie respostas
    # usando a tentativa de outro usuário.
    #
    # Também verificamos a avaliação para garantir
    # que a tentativa pertence a esta avaliação.
    # ------------------------------------------

    tentativa = get_object_or_404(
        Tentativa,
        id=tentativa_id,
        usuario=request.user,
        avaliacao=avaliacao
    )

    # ------------------------------------------
    # Busca todas as questões dessa avaliação
    # ------------------------------------------

    questoes = Questao.objects.filter(
        avaliacao=avaliacao
    )

    # ------------------------------------------
    # Percorre todas as questões
    # ------------------------------------------

    for questao in questoes:

        # ======================================
        # QUESTÃO DE MÚLTIPLA ESCOLHA
        # ======================================

        if questao.tipo == 'multipla':

            # O template deve enviar:
            #
            # alternativa_{{ questao.id }}
            #
            alternativa_id = request.POST.get(
                f'alternativa_{questao.id}'
            )

            # Se o usuário respondeu essa questão
            if alternativa_id:

                # Busca a alternativa e garante
                # que ela realmente pertence à questão
                alternativa = get_object_or_404(
                    Alternativa,
                    id=alternativa_id,
                    questao=questao
                )

                # ----------------------------------
                # Salva a resposta relacionada à
                # TENTATIVA, e não diretamente
                # ao usuário.
                #
                # Isso permite que o mesmo usuário
                # tenha respostas diferentes em
                # diferentes tentativas.
                # ----------------------------------

                RespostaUsuario.objects.update_or_create(
                    tentativa=tentativa,
                    questao=questao,
                    defaults={
                        'alternativa': alternativa,
                        'resposta_texto': None
                    }
                )

        # ======================================
        # QUESTÃO ABERTA
        # ======================================

        elif questao.tipo == 'aberta':

            # O template deve enviar:
            #
            # resposta_{{ questao.id }}
            #
            resposta_texto = request.POST.get(
                f'resposta_{questao.id}'
            )

            if resposta_texto:

                resposta_texto = resposta_texto.strip()

                if resposta_texto:

                    # Salva a resposta relacionada
                    # à tentativa atual
                    RespostaUsuario.objects.update_or_create(
                        tentativa=tentativa,
                        questao=questao,
                        defaults={
                            'alternativa': None,
                            'resposta_texto': resposta_texto
                        }
                    )

    # ------------------------------------------
    # Marca a tentativa como finalizada
    # ------------------------------------------

    from django.utils import timezone

    tentativa.finalizada_em = timezone.now()

    tentativa.save()

    # ------------------------------------------
    # Mensagem de sucesso
    # ------------------------------------------

    messages.success(
        request,
        "Respostas enviadas com sucesso."
    )

    return redirect('home')