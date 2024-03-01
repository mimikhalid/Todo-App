from django.urls import path
from .views import GetCreateToDo, UpdateDeleteTodo

urlpatterns = [
    path('', GetCreateToDo.as_view()),
    path('<int:pk>', UpdateDeleteTodo.as_view())
]
