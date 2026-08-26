from django.db import models
from django.contrib.auth import get_user_model
User = get_user_model()
from django.core.exceptions import ValidationError


# =========================================
# TIPOS PADRÃO DE ATIVIDADE
# =========================================

class TipoAtividade(models.Model):

    nome = models.CharField(
        max_length=30,
        unique=True
    )

    def __str__(self):
        return self.nome


# =========================================
# ATIVIDADES DO USUÁRIO
# =========================================

class Atividades(models.Model):

    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    nome_atividade = models.CharField(
        max_length=30
    )

    data_criacao = models.DateTimeField(
        auto_now_add=True
    )

    tipo = models.ForeignKey(
        TipoAtividade,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )

    class Meta:

        unique_together = [
            'usuario',
            'nome_atividade'
        ]

    def __str__(self):
        return self.nome_atividade


# =========================================
# REGISTROS DIÁRIOS DAS ATIVIDADES
# =========================================

class Registro(models.Model):

    atividade = models.ForeignKey(
        Atividades,
        on_delete=models.CASCADE
    )

    data = models.DateField()

    class Meta:

        unique_together = (
            'atividade',
            'data'
        )

    def __str__(self):
        return f"{self.atividade.nome_atividade} - {self.data}"


# =========================================
# QUIZ OU PROVA
# =========================================

class Avaliacao(models.Model):

    TIPO_CHOICES = [
        ('quiz', 'Quiz'),
        ('prova', 'Prova')
    ]

    titulo = models.CharField(
        max_length=100
    )

    tipo = models.CharField(
        max_length=10,
        choices=TIPO_CHOICES
    )

    professor = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    data_criacao = models.DateTimeField(
        auto_now_add=True
    )
    
    tentativas_permitidas = models.IntegerField(
        null=True,
        blank=True
    )
    
    

    def __str__(self):
        return self.titulo


# =========================================
# QUESTÕES
# =========================================

class Questao(models.Model):

    TIPO_QUESTAO = [
        ('multipla', 'Multipla Escolha'),
        ('aberta', 'Resposta Aberta'),
    ]

    avaliacao = models.ForeignKey(
        Avaliacao,
        on_delete=models.CASCADE
    )

    enunciado = models.TextField()

    tipo = models.CharField(
        max_length=10,
        choices=TIPO_QUESTAO
    )

    def __str__(self):
        return self.enunciado


# =========================================
# ALTERNATIVAS DAS QUESTÕES
# =========================================

class Alternativa(models.Model):

    questao = models.ForeignKey(
        Questao,
        on_delete=models.CASCADE
    )

    texto = models.CharField(
        max_length=200
    )

    correta = models.BooleanField(
        default=False
    )

    def __str__(self):
        return self.texto


# =========================================
# RESPOSTAS DOS USUÁRIOS
# =========================================

class RespostaUsuario(models.Model):

    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    questao = models.ForeignKey(
        Questao,
        on_delete=models.CASCADE
    )

    alternativa = models.ForeignKey(
        Alternativa,
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )

    resposta_texto = models.TextField(
        null=True,
        blank=True
    )

    data_resposta = models.DateTimeField(
        auto_now_add=True
    )

    class Meta:

        unique_together = (
            'usuario',
            'questao'
        )

class Conteudo(models.Model):

    titulo = models.CharField(
        max_length=200
    )

    texto = models.TextField()

    criado_em = models.DateTimeField(
        auto_now_add=True
    )

    def __str__(self):
        return self.titulo

class Tentativa(models.Model):
    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    avaliacao = models.ForeignKey(
        Avaliacao,
        on_delete=models.CASCADE
    )

    numero = models.IntegerField()

    nota = models.FloatField(
        null=True,
        blank=True
    )

    iniciada_em = models.DateTimeField(
        auto_now_add=True
    )

    finalizada_em = models.DateTimeField(
        null=True,
        blank=True
    )


