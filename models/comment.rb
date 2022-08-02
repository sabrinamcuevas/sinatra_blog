class Comment < ActiveRecord::Base
  has_many :users
  validates :comment, presence: true
  validates_length_of :comment, minimum: 5, maximum: 1024
  has_many :children, -> { order('created_at ASC') }, class_name: "Comment", foreign_key: "parent_id", :dependent => :destroy
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :article

  def self.create(data:, user:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?
    comments = new(get_params(data, user))
    if comments.save
      result = {
                id: comments.id,
                user_id: comments.user.id,
                alias: comments.user.alias,
                photo: comments.user.photo,
                comment: comments.comment,
                created_at: comments.created_at,
                parent_id: comments.parent_id,
                article_id: comments.article.present? ? comments.article.id : nil
                }
      { message: 'success!', comment: result, status: :ok }.to_json
    else
      { message: 'error!', status: :unprocessable_entity }.to_json
    end
  end

  def self.get_params(data, user)
    { comment: data['comment'],
      article_id: data['article_id'],
      parent_id: data['parent_id'],
      user_id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email }
  end

  def self.get_article_comments(params, user)
    return { error: 'article_id es requerido' }.to_json if !params['article_id'].present?
    return { error: 'Limit is not a number' }.to_json  if params['limit'].present? && !SscoolService.is_numeric?(params['limit'].to_i)
    return { error: 'Offset is not a number' }.to_json if params['offset'].present? && !SscoolService.is_numeric?(params['offset'].to_i)

    return { error: 'parent_id is not a number' }.to_json if params['parent_id'].present? && !SscoolService.is_numeric?(params['parent_id'].to_i)
    return { error: 'article_id is not a number' }.to_json if params['article_id'].present? && !SscoolService.is_numeric?(params['article_id'].to_i)
    return { error: 'Limit exceeds maximum' }.to_json if params['limit'].to_i > 50
    array_comment = []

    if params['parent_id'].present?
      Comment.where(article_id: params['article_id'].to_i, parent_id: params['parent_id'].to_i).order('created_at desc').each do |user_comment|
        user = User.find(user_comment.user.id)
        array_comment << {
                          id: user_comment.id,
                          alias: user.alias,
                          created_at: user_comment.created_at,
                          photo: user.photo,
                          comment: user_comment.comment
                         }

      end
    else
      Comment.where(article_id: params['article_id'].to_i,  parent_id: nil).order('created_at desc').each do |user_comment|
        user = User.find(user_comment.user.id)
        array_comment << {
                          id: user_comment.id,
                          alias: user.alias,
                          count_child: Comment.where(parent_id: user_comment.id).count,
                          created_at: user_comment.created_at,
                          photo: user.photo,
                          comment: user_comment.comment
                        }

      end
    end

    offset = params['offset'].present? && params['offset'].to_i > 0 ? params['offset'].to_i : 0
    #falta order
    result = !array_comment.empty? && params['limit'].present? ? array_comment[offset,params['limit'].to_i] : array_comment
    return { array_comment: result, count: array_comment.count }

  end

  def self.get_count_total(params)
    return { error: 'article_id es requerido' } unless params['article_id'].present?

    count_parents = Comment.where(article_id: params['article_id'].to_i, parent_id: nil).count
    count_childrens = Comment.where(article_id: params['article_id'].to_i).where.not(parent_id: nil).count

    return { count_parents: count_parents, count_childrens: count_childrens }
  end

  def user
    User.find(user_id)
  end

  private


end
