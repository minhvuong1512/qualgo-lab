locals {
  default_repository = try(var.container_image_overrides.default_repository, local.published_repository)
  default_tag        = try(var.container_image_overrides.default_tag, local.published_tag)

  nestjs_backend_default_image = "${local.default_repository}/nestjs-backend:${local.default_tag}"
  nestjs_backend_image         = try(var.container_image_overrides.nestjs_backend, local.nestjs_backend_default_image)

  nextjs_frontend_ui_default_image = "${local.default_repository}/nextjs-frontend-ui:${local.default_tag}"
  nextjs_frontend_ui_image         = try(var.container_image_overrides.nextjs_frontend_ui, local.nextjs_frontend_ui_default_image)
}
