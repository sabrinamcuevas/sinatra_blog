require 'json'

desc 'Script para actualizar el article_title_id, ya que en la primera migracion no se guardo correctamente la informacion'

task :update_article_title_id do
  puts '**** Inicio recorrido de articulos ****'
  articles = Article.all

  articles.each do |article|
    article_title_id = JSON.parse(article.title)
    article_title_id_es = article_title_id['es'].nil? ? '' : SscoolService.to_slug(article_title_id['es'])
    article_title_id_en = article_title_id['en'].nil? ? '' : SscoolService.to_slug(article_title_id['en'])
    article.article_title_id = '{ "es": ' + '"' + article_title_id_es + '", "en": "' + article_title_id_en + '"}'
    article.save
  end
  puts '****  ****'
end
