require 'nokogiri'
require 'json'


desc 'Script para migrar todos los articulos (PODCASTS) de core para la base de datos de Comunidad / SSCOOL'

task :data_migration_podcasts do 
    articles_const = [
    {
        image_url: {
                "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_1.jpg",
                "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_1.jpg",
                "medium": "#{ENV['BASE_URL_CORE']}m/images/podcast/episode_1.jpg",
                "thumbnail": "#{ENV['BASE_URL_CORE']}images/podcast/episode_1.jpg"
        },
        title: "Episodio 1",
        description: "Fer Carolei en este primer episodio de \"La libertad de tus finanzas\" conversa a solas con Vero Silva acerca de su experiencia creando Apprendo.",
        link: "https://open.spotify.com/episode/1uK1R8cbA7CrWlkk1m6OZr?si=9c0f659885fa4e74"
      },
      {
        image_url: {
            "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_2.jpg",
            "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_2.jpg",
            "medium": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_2.jpg",
            "thumbnail": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_2.jpg"
        },
        title: "Episodio 2",
        description: "Guido Quaranta y la intimidad de la tarjeta SeSocio, primer tarjeta 100% transparente de Argentina.",
        link: "https://open.spotify.com/episode/5ASyqn4OeCTxDHx3uiHK3D?si=08724b265a434dce"
      },
      {
        image_url: {
            "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_3.jpg",
            "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_3.jpg",
            "medium": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_3.jpg",
            "thumbnail": "#{ENV['BASE_URL_CORE']}com/images/podcast/episode_3.jpg"
        },
        title: "Episodio 3",
        description: "Christian Petersen y la cocina de un gran emprendedor. Consejos, fama, logros, fracasos y mucho más.",
        link: "https://open.spotify.com/episode/273ov1P4SaXCmMQWEpC2BP?si=a2041430e3994245"
      },
      {
        image_url: {
            "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_4.jpg",
            "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_4.jpg",
            "medium": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_4.jpg",
            "thumbnail": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_4.jpg"
        },
        title: "Episodio 4",
        description: "Marcela Pagano nos cuenta cómo invertir en Argentina y qué factores tener en cuenta en un contexto de elecciones.",
        link: "https://open.spotify.com/episode/3hYirKszJjpIbgHN6OSBtE?si=e81983eff7844a06"
      },
      {
        image_url: {
            "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_5.jpg",
            "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_5.jpg",
            "medium": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_5.jpg",
            "thumbnail": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_5.jpg"
        },
        title: "Episodio 5",
        description: "Jorge Bellsolá conversa con Fer Carolei sobre el proyecto \"Seamos Bosques\" y la acción llevada en conjunto con SeSocio. ¿Hay casos de éxitos en el cambio climático?",
        link: "https://open.spotify.com/episode/09t0b0OjovBN8EIxrT49Cq?si=daa2ee3032594239"
      },
      {
        image_url: {
            "large": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_6.jpg",
            "small": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_6.jpg",
            "medium": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_6.jpg",
            "thumbnail": "#{ENV['BASE_URL_CORE']}/images/podcast/episode_6.jpg"
        },
        title: "Episodio 6",
        description: "Walter Queijeiro, periodista deportivo, nos cuenta ¿Como ahorrar para invertir? ¿Por donde comenzar? asociado al mundo del futbol.",
        link: "https://open.spotify.com/episode/6wUc83BGr6nYXYyxF8bkLW?si=ea2987c7961242b5"
      }
    ]

    section_sscool = Section.new(type: :podcast, name: 'Podcasts', description: 'Podcasts', image_url: nil, section_title_id: SscoolService.to_slug('podcasts'))
    section_sscool.save!

    chapter_sscool = Chapter.new(section_id: section_sscool.id, position: 1, name: 'Capítulo 1', description: "#{section_sscool.name} - Capítulo 1", image_url: nil, chapter_title_id: SscoolService.to_slug('Capítulo 1'))
    chapter_sscool.save!

    puts "Soy PODCASTS ..."
    puts "Procesando ..."

    articles_const.each.with_index(1) do |art, index|
        data = JSON.parse(art.to_json)
        article = Article.new(
            section_id: section_sscool.id,
            chapter_id: chapter_sscool.id,
            body: { es: data['link'] },
            title: { es: data['title'] },
            short_description: data['description'],
            published: true,
            reading_time: get_reading_time(data['description']),
            position: index,
            published_at: Time.now,
            image_url: data['image_url'],
            new: false,
            difficulty_level: 0,
            introduction: { es: data['description'] },
            article_title_id: { es: data['link'] },
            created_at: Time.now
        )
        article.save!

        article.image_url = article.image_url.gsub("=>", ":")
        article.body = article.body.gsub(":es=>", '"es":')
        article.title = article.title.gsub(":es=>", '"es":')
        article.introduction =  article.introduction.gsub(":es=>", '"es":')
        article.article_title_id =  article.article_title_id.gsub(":es=>", '"es":')

        article.save!
        
    end   

    puts "**** Finalice la migracion articulos podcasts ****"
end