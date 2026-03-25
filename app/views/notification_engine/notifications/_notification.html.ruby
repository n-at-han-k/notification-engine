concat(turbo_frame_tag(dom_id(notification)) {
  capture {
    Segment(
      secondary: notification.read?,
      color: notification.unread? ? "blue" : nil
    ) {
      HStack(justify: "between", align: "center") {
        HStack(align: "center", spacing: 8) {
          Icon(name: "circle", size: "small", color: "blue") if notification.unread?
          VStack(spacing: 2) {
            msg = notification.respond_to?(:message) ? notification.message : notification.type.demodulize.underscore.humanize
            text msg
            Text(size: "small", color: "grey") {
              text "#{time_ago_in_words(notification.created_at)} ago"
            }
          }
        }
        HStack(spacing: 4) {
          if notification.unread?
            concat button_to("Read", mark_as_read_notification_path(notification), method: :patch, class: "ui basic tiny button")
          else
            concat button_to("Unread", mark_as_unread_notification_path(notification), method: :patch, class: "ui basic tiny button")
          end
          concat button_to("Remove", notification_path(notification), method: :delete, class: "ui basic tiny red button")
        }
      }
    }
  }
})
