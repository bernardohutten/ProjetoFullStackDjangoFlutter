from rest_framework import serializers

from .models import (
    Atividades,
    Registro,
    Avaliacao,
    Questao,
    Alternativa,
    RespostaUsuario,
    Conteudo
)


class AtividadesSerializer(serializers.ModelSerializer):
    tipo_nome = serializers.SerializerMethodField()
    total_registros = serializers.SerializerMethodField()

    class Meta:
        model = Atividades

        fields = [
            'id',
            'nome_atividade',
            'data_criacao',
            'tipo',
            'tipo_nome',
            'total_registros',
        ]

        read_only_fields = [
            'id',
            'data_criacao',
            'tipo',
            'tipo_nome',
            'total_registros',
        ]

    def get_tipo_nome(self, obj):
        if obj.tipo:
            return obj.tipo.nome
        return None

    def get_total_registros(self, obj):
        return obj.registro_set.count()


class RegistroSerializer(serializers.ModelSerializer):
    atividade_nome = serializers.SerializerMethodField()

    class Meta:
        model = Registro

        fields = [
            'id',
            'atividade',
            'atividade_nome',
            'data',
        ]

        read_only_fields = [
            'id',
            'atividade_nome',
        ]

    def get_atividade_nome(self, obj):
        return obj.atividade.nome_atividade


class AlternativaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Alternativa

        fields = [
            'id',
            'texto',
        ]


class QuestaoSerializer(serializers.ModelSerializer):
    alternativas = serializers.SerializerMethodField()

    class Meta:
        model = Questao

        fields = [
            'id',
            'enunciado',
            'tipo',
            'alternativas',
        ]

    def get_alternativas(self, obj):
        alternativas = Alternativa.objects.filter(
            questao=obj
        )

        return AlternativaSerializer(
            alternativas,
            many=True
        ).data


class AvaliacaoSerializer(serializers.ModelSerializer):
    professor_nome = serializers.SerializerMethodField()
    total_questoes = serializers.SerializerMethodField()

    class Meta:
        model = Avaliacao

        fields = [
            'id',
            'titulo',
            'tipo',
            'professor_nome',
            'data_criacao',
            'total_questoes',
        ]

    def get_professor_nome(self, obj):
        return obj.professor.username

    def get_total_questoes(self, obj):
        return obj.questao_set.count()


class AvaliacaoDetalheSerializer(serializers.ModelSerializer):
    professor_nome = serializers.SerializerMethodField()
    questoes = serializers.SerializerMethodField()

    class Meta:
        model = Avaliacao

        fields = [
            'id',
            'titulo',
            'tipo',
            'professor_nome',
            'data_criacao',
            'questoes',
        ]

    def get_professor_nome(self, obj):
        return obj.professor.username

    def get_questoes(self, obj):
        questoes = Questao.objects.filter(
            avaliacao=obj
        )

        return QuestaoSerializer(
            questoes,
            many=True
        ).data


class RespostaUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = RespostaUsuario

        fields = [
            'id',
            'questao',
            'alternativa',
            'resposta_texto',
            'data_resposta',
        ]

        read_only_fields = [
            'id',
            'data_resposta',
        ]

class ConteudoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Conteudo

        fields = [
            'id',
            'titulo',
            'texto',
            'criado_em',
        ]