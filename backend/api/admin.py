from django.contrib import admin
from .models import Todo

# Register your models here.
admin.site.register(Todo)
class AdminTodo(admin.ModelAdmin):
    list_display = ["index_counter", "title", "description", "statusDone", "updated_at"]
    list_display_links = ['title']
    search_fields = ('title', 'description',)
    list_per_page = 15
    ordering = ["id"]

    def get_queryset(self, request):
        queryset = super().get_queryset(request)
        return queryset.order_by('id')

    def index_counter(self, obj):
        """
        Creating index
        """
        queryset = self.get_queryset(self)
        index = list(queryset).index(obj)
        return index + 1
    index_counter.short_description = 'No'