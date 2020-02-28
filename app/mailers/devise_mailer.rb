class DeviseMailer < Devise::Mailer
  helper :application

  layout "mailer_layout"
  default from: I18n.t("mailer.default.from")
end