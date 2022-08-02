require 'nokogiri'
require 'json'


desc 'Script para migrar todos los articulos (CAFE CRIPTO) de core para la base de datos de Comunidad / SSCOOL'

task :data_migration_crypto do 
    url = "#{ENV['BASE_URL_CORE']}/core/articles/get_articles/"
    params = 'press?query=con cripto'
    limit = 50
    offset = 0
    puts "**** Inicio recorrido de migracion de articulos crypto ****"
    section_sscool = create_section_sscool_crypto('Cafe Crypto')
    chapter_sscool = create_chapter_sscool_crypto(section_sscool)
    get_articles_by_params_from_core_crypto(params,url,limit,offset,section_sscool,chapter_sscool)
    puts "**** Finalice la migracion articulos crypto ****"
end

def get_articles_by_params_from_core_crypto(params, url,limit,offset,section_sscool,chapter_sscool)
    url_final = "#{url}#{limit}/#{offset}/#{params}"
    json_response = Core.make_request(:get, url: url_final)
    if json_response['articles'].any?
    puts "Soy Cafe Crypto y tengo #{json_response['count']}. Voy recorriendo el rango #{offset} a #{ offset + json_response['articles'].count}"
    puts "Procesando ..."
    insert_articles_sscool_crypto(json_response['articles'],section_sscool,chapter_sscool)
    offset+=limit
    get_articles_by_params_from_core_crypto(params,url,limit,offset,section_sscool,chapter_sscool)        
    end   
end

def create_section_sscool_crypto(section)
    section_sscool = Section.new(type: :cafe_crypto, name: format_name_section(section), description: format_name_section(section), image_url: nil, section_title_id: SscoolService.to_slug(section))
    section_sscool.save!
    section_sscool
end

def create_chapter_sscool_crypto(section_sscool)
    chapter_sscool = Chapter.new(section_id: section_sscool.id, position: 1, name: 'Capítulo 1', description: "#{section_sscool.name} - Capítulo 1", image_url: nil, chapter_title_id: SscoolService.to_slug('Capítulo 1'))
    chapter_sscool.save!
    chapter_sscool
end  

def format_name_section(section_name)
    replacements = {'_' => ''}
    section_name.gsub(Regexp.union(replacements.keys), replacements)
    section_name.camelcase(:upper)
end    

def insert_articles_sscool_crypto(array_articles,section_sscool,chapter_sscool)
    array_articles.each.with_index(1) do |data_article, index|
        article = Article.new(
            section_id: section_sscool.id,
            chapter_id: chapter_sscool.id,
            body: { es: data_article['article_detail'] },
            title: { es: data_article['article_title'] },
            short_description: data_article['short_description'].present? ? data_article['short_description'] : data_article['article_title'],
            published: true,
            reading_time: get_reading_time(data_article['article_detail']['es']),
            position: index,
            published_at: data_article['published_at'],
            image_url: data_article['photo_url'],
            new: false,
            difficulty_level: data_article['difficulty_level'],
            introduction: data_article['article_summary'].present? ?  { es: data_article['article_summary'] } : "",
            article_title_id: { es: data_article['article_title_id'] },
            created_at: data_article['created_at']
        )
        article.save!

        article.image_url = article.image_url.gsub("=>", ":")
        article.body = article.body.gsub(":es=>", '"es":')
        article.title = article.title.gsub(":es=>", '"es":')
        article.introduction =  article.introduction.gsub(":es=>", '"es":')
        article.article_title_id =  article.article_title_id.gsub(":es=>", '"es":')

        article.save!

    end     
end  

def get_reading_time(body_html)
    words_per_minute = 200
    text = Nokogiri::HTML(body_html).at('body').inner_text
    reading_time = (text.scan(/\w+/).length / words_per_minute).to_i
    return 1 if reading_time == 0
    reading_time
end   