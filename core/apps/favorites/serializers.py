from rest_framework import serializers
from apps.users.models import User
from apps.users.serializers import UserSerializer
from apps.workers.serializers import WorkerProfileSerializer
from .models import Favorite


class FavoriteSerializer(serializers.ModelSerializer):
    worker_info = serializers.SerializerMethodField()
    worker_id = serializers.PrimaryKeyRelatedField(
        queryset = User.objects.filter(role=User.Role.WORKER),
        source = "worker",
    )

    class Meta:
        model = Favorite
        fields = ["id", "worker_id", "worker_info", "created_at"]
        read_only_fields = ["id", "created_at"]

    def get_worker_info(self, obj):
        user = obj.worker
        if hasattr(user, "worker_profile"):
            return WorkerProfileSerializer(
                user.worker_profile,
                context=self.context,
            ).data
        return UserSerializer(user).data
