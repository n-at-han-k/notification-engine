# frozen_string_literal: true

module NotificationEngine
  class NotificationsController < ApplicationController
    before_action :set_notification, only: %i[mark_as_read mark_as_unread destroy]

    # GET /notifications
    # GET /notifications?filter=unread
    # GET /notifications?filter=read
    def index
      @notifications = filtered_notifications
    end

    # PATCH /notifications/:id/mark_as_read
    def mark_as_read
      @notification.mark_as_read!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notifications_path, notice: "Notification marked as read." }
      end
    end

    # PATCH /notifications/:id/mark_as_unread
    def mark_as_unread
      @notification.mark_as_unread!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notifications_path, notice: "Notification marked as unread." }
      end
    end

    # POST /notifications/mark_all_read
    def mark_all_read
      notifications_scope.unread.mark_as_read

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "notification_engine/notifications/list", locals: { notifications: filtered_notifications }) }
        format.html { redirect_to notifications_path, notice: "All notifications marked as read." }
      end
    end

    # DELETE /notifications/:id
    def destroy
      @notification.destroy

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notifications_path, notice: "Notification removed." }
      end
    end

    private

    def set_notification
      @notification = notifications_scope.find(params[:id])
    end

    def filtered_notifications
      scope = notifications_scope
      case params[:filter]
      when "unread" then scope.unread
      when "read"   then scope.read
      else scope
      end
    end
  end
end
