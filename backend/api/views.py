from django.shortcuts import render
from rest_framework import generics, serializers
from .models import Todo
from .serializers import TodoSerializer

class GetCreateToDo(generics.ListCreateAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

class UpdateDeleteTodo(generics.RetrieveUpdateDestroyAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

