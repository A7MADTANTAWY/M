from django.urls import path
from . import views

urlpatterns = [
    path("orders/", views.OrderListCreateView.as_view(), name="order-list-create"),
    path("orders/<int:pk>/", views.OrderDetailView.as_view(), name="order-detail"),
    path("orders/<int:pk>/accept/", views.OrderAcceptView.as_view(), name="order-accept"),
    path("orders/<int:pk>/reject/", views.OrderRejectView.as_view(), name="order-reject"),
    path("orders/<int:pk>/cancel/", views.OrderCancelView.as_view(), name="order-cancel"),
    path("orders/<int:pk>/mark-finished/", views.OrderMarkFinishedView.as_view(), name="order-mark-finished"),
    path("orders/<int:pk>/confirm-completion/", views.OrderConfirmCompletionView.as_view(), name="order-confirm-completion"),
]
