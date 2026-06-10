from django.contrib import admin

from .models import (
    TipoAtividade,
    Atividades,
    Registro,
    Avaliacao,
    Questao,
    Alternativa,
    RespostaUsuario,
    Conteudo,
)


@admin.register(TipoAtividade)
class TipoAtividadeAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'nome',
    )

    search_fields = (
        'nome',
    )


@admin.register(Atividades)
class AtividadesAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'nome_atividade',
        'usuario',
        'tipo',
        'data_criacao',
    )

    list_filter = (
        'tipo',
        'usuario',
        'data_criacao',
    )

    search_fields = (
        'nome_atividade',
        'usuario__username',
    )


@admin.register(Registro)
class RegistroAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'atividade',
        'data',
    )

    list_filter = (
        'data',
        'atividade',
    )

    search_fields = (
        'atividade__nome_atividade',
    )


@admin.register(Avaliacao)
class AvaliacaoAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'titulo',
        'tipo',
        'professor',
        'data_criacao',
    )

    list_filter = (
        'tipo',
        'professor',
        'data_criacao',
    )

    search_fields = (
        'titulo',
        'professor__username',
    )


@admin.register(Questao)
class QuestaoAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'avaliacao',
        'tipo',
        'enunciado',
    )

    list_filter = (
        'tipo',
        'avaliacao',
    )

    search_fields = (
        'enunciado',
        'avaliacao__titulo',
    )


@admin.register(Alternativa)
class AlternativaAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'questao',
        'texto',
        'correta',
    )

    list_filter = (
        'correta',
        'questao',
    )

    search_fields = (
        'texto',
        'questao__enunciado',
    )


@admin.register(RespostaUsuario)
class RespostaUsuarioAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'usuario',
        'questao',
        'alternativa',
        'resposta_texto',
        'data_resposta',
    )

    list_filter = (
        'usuario',
        'questao',
        'data_resposta',
    )

    search_fields = (
        'usuario__username',
        'questao__enunciado',
        'resposta_texto',
    )


@admin.register(Conteudo)
class ConteudoAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'titulo',
        'criado_em',
    )

    list_filter = (
        'criado_em',
    )

    search_fields = (
        'titulo',
        'texto',
    )