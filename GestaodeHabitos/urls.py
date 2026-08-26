from django.urls import path
from . import views


urlpatterns = [

    # ==========================================
    # HOME
    # ==========================================

    path(
        '',
        views.home,
        name='home'
    ),


    # ==========================================
    # AUTENTICAÇÃO
    # ==========================================

    path(
        'login/',
        views.login_usuario,
        name='login_usuario'
    ),

    path(
        'cadastrar/',
        views.cadastrar_usuario,
        name='cadastrar_usuario'
    ),

    path(
        'logout/',
        views.logout_usuario,
        name='logout_usuario'
    ),


    # ==========================================
    # ATIVIDADES
    # ==========================================

    path(
        'criar-atividade/',
        views.criar_atividade,
        name='criar_atividade'
    ),

    path(
        'registrar-atividade/<int:atividade_id>/',
        views.registrar_atividade,
        name='registrar_atividade'
    ),

    path(
        'deletar-atividade/<int:id>/',
        views.deletar_atividade,
        name='deletar_atividade'
    ),


    # ==========================================
    # ESTUDAR
    # ==========================================

    path(
        'estudar/',
        views.estudar,
        name='estudar'
    ),


    # ==========================================
    # QUIZZES E PROVAS
    # ==========================================

    path(
        'quizzes/',
        views.listar_quizzes,
        name='listar_quizzes'
    ),

    path(
        'provas/',
        views.listar_provas,
        name='listar_provas'
    ),

    path(
        'quiz/<int:avaliacao_id>/',
        views.quiz,
        name='quiz'
    ),

    path(
        'prova/<int:avaliacao_id>/<int:tentativa_id>/',
        views.prova,
        name='prova'
    ),


    # ==========================================
    # CRIAÇÃO DE AVALIAÇÕES
    # ==========================================

    path(
        'avaliacao/criar/',
        views.criar_avaliacao,
        name='criar_avaliacao'
    ),

    path(
        'avaliacao/<int:avaliacao_id>/questao/criar/',
        views.criar_questao,
        name='criar_questao'
    ),

    path(
        'questao/<int:questao_id>/alternativas/',
        views.criar_alternativas,
        name='criar_alternativas'
    ),


    # ==========================================
    # RESPOSTAS DAS AVALIAÇÕES
    # ==========================================

    path(
        'avaliacao/<int:avaliacao_id>/responder/',
        views.responder_avaliacao,
        name='responder_avaliacao'
    ),
]