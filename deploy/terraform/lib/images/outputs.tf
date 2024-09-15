output "result" {
  value = {
    nestjs_backend = merge({
      url = local.nestjs_backend_image
    }, zipmap(["repository", "tag"], split(":", local.nestjs_backend_image)))
    nextjs_frontend_ui = merge({
      url = local.nextjs_frontend_ui_image
    }, zipmap(["repository", "tag"], split(":", local.nextjs_frontend_ui_image)))
  }
}
