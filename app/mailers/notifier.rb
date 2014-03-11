class Notifier < ActionMailer::Base
  default from: 'Libanco <soporte@libanco.com>'

  def remind(reminder)
    @reminder = reminder

    mail to: @reminder.user_email
  end

  def summary(user)
    @user = user
    @schedules = user.schedules.for_tomorrow

    mail to: user.email
  end
end