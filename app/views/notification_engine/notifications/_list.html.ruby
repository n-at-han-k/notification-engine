concat tag.div(id: "notifications") {
  capture {
    if notifications.any?
      notifications.each do |notification|
        concat render(partial: "notification_engine/notifications/notification", locals: { notification: notification })
      end
    else
      Segment(placeholder_seg: true) {
        VStack(align: "center", spacing: 8) {
          Icon(name: "check circle outline", size: "huge", color: "green")
          Header(size: :h3) { text "All caught up!" }
        }
      }
    end
  }
}
