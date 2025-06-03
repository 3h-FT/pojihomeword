module ApplicationHelper
  def default_meta_tags
    {
      site: 'ポジほめワード',
      title: 'ポジほめワード',
      reverse: true,
      charset: 'utf-8',
      description: 'ポジティブな言葉を「知る」・「ためる」・「共有する」ことのできるアプリです。',
      keywords: 'ポジティブ,ほめる,ワード,知る,ためる,共有',
      canonical: request.original_url,
      separator: '|', #Webサイト名とページタイトルを区切るために使用されるテキスト
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('default_ogp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('default_ogp.png')
      }
    }
  end
end
