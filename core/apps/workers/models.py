from django.db import models
from django.conf import settings


class ServiceCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)
    image = models.ImageField(
        upload_to="categories/",
        null=True,
        blank=True,
    )

    def __str__(self):
        return self.name


class WorkerProfile(models.Model):

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="worker_profile",
    )
    category = models.ForeignKey(
        ServiceCategory,
        on_delete=models.PROTECT,
        related_name="workers",
        null=True,
        blank=True,
    )
    description = models.TextField(max_length=500, blank=True)
    experience_years = models.PositiveIntegerField(default=0)
    average_rating = models.FloatField(default=0.0)
    completed_jobs = models.PositiveIntegerField(default=0)
    is_available = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        cat = self.category.name if self.category else "No category"
        return f"{self.user.username} - {cat}"

    def calculate_score(self):
        return (self.average_rating * 0.6) + (self.completed_jobs * 0.4)
