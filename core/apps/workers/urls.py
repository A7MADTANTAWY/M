from django.urls import path
from . import views
from apps.ratings.views import WorkerRatingListAPIView, WorkerRatingsDetailView

urlpatterns = [
    path("categories/",        views.ServiceCategoryListView.as_view(),    name="category-list"),
    path("categories/create/", views.ServiceCategoryCreateView.as_view(),  name="category-create"),
    path("workers/",           views.WorkerListView.as_view(),      name="worker-list"),
    path("workers/create/",    views.WorkerCreateView.as_view(),    name="worker-create"),
    path("workers/me/",        views.MyWorkerProfileView.as_view(), name="worker-me"),
    path("workers/my-ratings/", WorkerRatingListAPIView.as_view(),  name="worker-my-ratings"),
    path("workers/<int:pk>/ratings/", WorkerRatingsDetailView.as_view(), name="worker-ratings"),
    path("workers/<int:pk>/",  views.WorkerDetailView.as_view(),    name="worker-detail"),
]
