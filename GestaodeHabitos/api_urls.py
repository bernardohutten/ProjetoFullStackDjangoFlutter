from django.urls import path
from . import api_views


urlpatterns = [

    # ==========================================
    # ATIVIDADES
    # ==========================================

    # LISTAR atividades do usuário logado
    path(
        'atividades/',
        api_views.minhas_atividades,
        name='api_minhas_atividades'
    ),

    # CRIAR nova atividade
    path(
        'atividades/criar/',
        api_views.criar_atividade_api,
        name='api_criar_atividade'
    ),

    # REGISTRAR atividade no dia
    path(
        'atividades/<int:atividade_id>/registrar/',
        api_views.registrar_atividade_api,
        name='api_registrar_atividade'
    ),

    # DELETAR atividade
    path(
        'atividades/<int:atividade_id>/deletar/',
        api_views.deletar_atividade_api,
        name='api_deletar_atividade'
    ),


    # ==========================================
    # AVALIAÇÕES
    # ==========================================

    # LISTAR quizzes e provas
    path(
        'avaliacoes/',
        api_views.listar_avaliacoes_api,
        name='api_listar_avaliacoes'
    ),

    # DETALHE da avaliação
    # traz questões e alternativas
    path(
        'avaliacoes/<int:avaliacao_id>/',
        api_views.detalhe_avaliacao_api,
        name='api_detalhe_avaliacao'
    ),

    # ENVIAR respostas do usuário
    path(
        'avaliacoes/<int:avaliacao_id>/responder/',
        api_views.responder_avaliacao_api,
        name='api_responder_avaliacao'
    ),
    path(
    'cadastro/',
    api_views.cadastrar_usuario_api,
    name='api_cadastrar_usuario'
    ),

    path(
    'me/',
    api_views.me_api,
    name='api_me'
    ),

    path(
    'conteudos/',
    api_views.listar_conteudos_api,
    name='api_conteudos'
    ),
]   
