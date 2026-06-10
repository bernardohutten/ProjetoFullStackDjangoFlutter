"""
URL configuration for projetodjangoportfolio project.
"""

from django.contrib import admin
from django.urls import path, include

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)


urlpatterns = [
    path('admin/', admin.site.urls),

    # URLs normais do seu app Django, com templates HTML
    path('', include('GestaodeHabitos.urls')),

    # URLs da API REST para Flutter
    path('api/', include('GestaodeHabitos.api_urls')),

    # Login via JWT
    path(
        'api/token/',
        TokenObtainPairView.as_view(),
        name='token_obtain_pair'
    ),

    # Renovar token JWT
    path(
        'api/token/refresh/',
        TokenRefreshView.as_view(),
        name='token_refresh'
    ),
]