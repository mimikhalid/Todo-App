from django.db import models
from django.core.exceptions import ValidationError

# Create your models here.
class Todo(models.Model):
    title = models.CharField(max_length=100)
    description = models.CharField(max_length=250)
    statusDone =  models.BooleanField(default=False, verbose_name="Status",)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True, verbose_name="Date",)

    def __str__(self):
        return self.title

    def clean(self):
        super().clean()

        # Validate the title
        if not self.title:
            raise ValidationError("Title cannot be empty")

        # Validate the description
        if not self.description:
            raise ValidationError("Description cannot be empty")


