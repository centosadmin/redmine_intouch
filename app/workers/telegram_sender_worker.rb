class TelegramSenderWorker
  include Sidekiq::Worker

  def perform(issue_id, state)
    issue = Issue.find issue_id

    message = issue.telegram_message

    token = Setting.plugin_redmine_intouch['telegram_bot_token']
    bot = Telegrammer::Bot.new(token)

    issue.intouch_recipients('telegram', state).each do |user|
      telegram_user = user.telegram_user
      next unless telegram_user.present?
      bot.send_message(chat_id: telegram_user.tid, text: message)
    end
  end

end