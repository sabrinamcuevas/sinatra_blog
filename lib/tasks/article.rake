require 'nokogiri'
require 'json'

desc 'Script para migrar todos los articulos (GUIDE) de core para la base de datos de Comunidad / SSCOOL'

task :data_migration do
    url = "#{ENV['BASE_URL_CORE']}/core/articles/get_articles_academy/"
    sections = ['sesocio_guide', 'investoland_guide', 'crypto_guide', 'financial_education_guide']
    limit = 50
    offset = 0
    puts "**** Inicio recorrido de migracion de guias ****"
    sections.each do |section|
        section_sscool = create_section_sscool(section)
        chapter_sscool = create_chapter_sscool(section_sscool)
        get_articles_by_section_from_core(section,url,limit,offset,section_sscool,chapter_sscool)
    end
    puts "**** Finalice la migracion ****"
end

def get_articles_by_section_from_core(section, url,limit,offset,section_sscool,chapter_sscool)
    url_section = "#{url}#{limit}/#{offset}?category=#{section}"
    json_response = Core.make_request(:get, url: url_section)
    if json_response['articles'].any?
        puts "Soy la seccion: #{section} y tengo #{json_response['count']}. Voy recorriendo el rango #{offset} a #{ offset + json_response['articles'][section].count}"
        puts "Procesando ..."
        insert_articles_sscool(json_response['articles'][section],section_sscool,chapter_sscool)
        offset+=limit
        get_articles_by_section_from_core(section,url,limit,offset,section_sscool,chapter_sscool)        
    end   
end

def create_section_sscool(section)
    section_sscool = Section.new(type: :guide, name: format_name_section(section), description: format_name_section(section), image_url: nil, section_title_id: SscoolService.to_slug(format_name_section(section)) )
    section_sscool.save!
    section_sscool
end

def create_chapter_sscool(section_sscool)
    chapter_sscool = Chapter.new(section_id: section_sscool.id, position: 1, name: 'Capítulo 1', description: "#{section_sscool.name} - Capítulo 1", image_url: nil, chapter_title_id: SscoolService.to_slug('Capítulo 1') )
    chapter_sscool.save!
    chapter_sscool
end  

def format_name_section(section_name)
    replacements = {'_' => ''}
    section_name.gsub(Regexp.union(replacements.keys), replacements)
    section_name.camelcase(:upper)
end    

def insert_articles_sscool(array_articles,section_sscool,chapter_sscool)
    array_articles.each.with_index(1) do |data_article, index|
        article = Article.new(
            section_id: section_sscool.id,
            chapter_id: chapter_sscool.id,
            body: data_article['article_detail'],
            title: data_article['article_title'],
            short_description: data_article['short_description'],
            published: true,
            reading_time: get_reading_time(data_article['article_detail']['es']),
            position: index,
            published_at: data_article['published_at'],
            image_url: data_article['photo_url'],
            new: false,
            difficulty_level: data_article['difficulty_level'],
            introduction: data_article['article_summary'].present? ? data_article['article_summary'] : "",
            article_title_id: data_article['article_title_id'],
            created_at: data_article['created_at']
        )
        article.save!

        article.body = article.body.gsub("=>", ":")
        article.title = article.title.gsub("=>", ":")
        article.image_url = article.image_url.gsub("=>", ":")
        article.introduction = article.introduction.gsub("=>", ":")
        article.article_title_id = article.article_title_id.gsub("=>", ":")

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