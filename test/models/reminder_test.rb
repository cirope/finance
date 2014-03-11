require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  def setup
    @reminder = reminders(:reminder)
  end

  test 'blank attributes' do
    @reminder.remind_at = nil
    @reminder.kind = ''

    assert @reminder.invalid?
    assert_error @reminder, :remind_at, :blank
    assert_error @reminder, :kind, :blank
  end

  test 'attributes length' do
    @reminder.kind = 'abcde' * 52

    assert @reminder.invalid?
    assert_error @reminder, :kind, :too_long, count: 255
  end

  test 'attributes inclusion' do
    @reminder.kind = 'kind'

    assert @reminder.invalid?
    assert_error @reminder, :kind, :inclusion
  end

  test 'validates date and time attributes' do
    @reminder.remind_at = '13/13/13'

    assert @reminder.invalid?
    assert_error @reminder, :remind_at, :invalid_datetime

    @reminder.remind_at = @reminder.scheduled_at + 1.minute

    assert @reminder.invalid?
    assert_error @reminder, :remind_at, :on_or_before,
      restriction: I18n.l(@reminder.scheduled_at, format: :minimal)
  end

  test 'delivery' do
    r1, r2, r3, r4 = @reminder.dup, @reminder.dup, @reminder.dup, @reminder.dup

    r1.remind_at = 1.hour.from_now # Too far away
    r2.remind_at = 1.minute.from_now; r2.notified = true # Already notified
    r3.remind_at = 1.minute.from_now # This must be sended
    r4.remind_at = 1.minute.ago # This also must be sended

    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      Reminder.send_reminders
    end

    { r1 => false, r2 => true, r3 => true, r4 => true }.each do |r, notified|
      assert r.reload.scheduled == notified && r.reload.notified == notified
    end
  end

  test 'destruction constraints' do
    @reminder.update_attributes! scheduled: true

    assert_no_difference 'Reminder.count'  do
      @reminder.destroy
    end
  end
end