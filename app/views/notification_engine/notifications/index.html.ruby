Container {
  Header(size: :h2, dividing: true) { text "Notifications" }
  Menu(secondary: true, pointing: true) {
    MenuItem(href: notifications_path, active: params[:filter].blank?) { text "All" }
    MenuItem(href: notifications_path(filter: "unread"), active: params[:filter] == "unread") { text "Unread" }
    MenuItem(href: notifications_path(filter: "read"), active: params[:filter] == "read") { text "Read" }
    SubMenu(position: "right") {
      MenuItem {
        concat button_to("Mark all as read", mark_all_read_notifications_path, method: :post, class: "ui basic small button")
      }
    }
  }
  concat render(partial: "notification_engine/notifications/list", locals: { notifications: @notifications })
}
