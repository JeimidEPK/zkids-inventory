class SyncMailer < ApplicationMailer

  def sync_results(results)
    @results = results
    mail(to: Figaro.env.admin_mail, subject: 'La sincronización de productos ha terminado')
  end
end
