from django.db import models
from django.core.exceptions import ValidationError
from apps.users.models import User
from apps.workers.models import ServiceCategory


class Order(models.Model):
    PENDING = "PENDING"
    ACCEPTED = "ACCEPTED"
    IN_PROGRESS = "IN_PROGRESS"
    WAITING_CONFIRMATION = "WAITING_CONFIRMATION"
    REJECTED = "REJECTED"
    CANCELLED = "CANCELLED"
    COMPLETED = "COMPLETED"

    STATUS_CHOICES = [
        (PENDING, "Pending"),
        (ACCEPTED, "Accepted"),
        (IN_PROGRESS, "In Progress"),
        (WAITING_CONFIRMATION, "Waiting Confirmation"),
        (REJECTED, "Rejected"),
        (CANCELLED, "Cancelled"),
        (COMPLETED, "Completed"),
    ]

    ALLOWED_TRANSITIONS = {
        PENDING: {ACCEPTED, REJECTED, CANCELLED},
        ACCEPTED: {IN_PROGRESS, CANCELLED, WAITING_CONFIRMATION},
        IN_PROGRESS: {WAITING_CONFIRMATION},
        WAITING_CONFIRMATION: {COMPLETED, CANCELLED},
        REJECTED: set(),
        CANCELLED: set(),
        COMPLETED: set(),
    }

    client = models.ForeignKey(
        User,
        on_delete = models.CASCADE,
        related_name = "my_orders",
    )
    worker = models.ForeignKey(
        User,
        on_delete = models.SET_NULL,
        null = True,
        blank = True,
        related_name = "assigned_orders",
    )
        
    service_category = models.ForeignKey(
        ServiceCategory,
        on_delete = models.PROTECT,
    )
    description = models.TextField(blank=True, default="")
    address = models.CharField(max_length=255, blank=True, default="")
    phone = models.CharField(max_length=20, blank=True, default="")
    status = models.CharField(
        max_length = 20,
        choices = STATUS_CHOICES,
        default = PENDING,
    )

    created_at = models.DateTimeField(auto_now_add=True)
    accepted_at  = models.DateTimeField(null=True, blank=True)
    started_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    rejected_at = models.DateTimeField(null=True, blank=True)
    cancelled_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Order #{self.id} [{self.status}] - {self.client.username}"

    def clean(self):
        if not self.description or not self.description.strip():
            raise ValidationError({"description": "Order description is required."})

    def can_transition_to(self, new_status):
        return new_status in self.ALLOWED_TRANSITIONS.get(self.status, set())

    def validate_transition_to(self, new_status):
        if not self.can_transition_to(new_status):
            raise ValidationError(
                {
                    "status": (
                        f"Cannot transition order from {self.status} "
                        f"to {new_status}."
                    )
                }
            )
