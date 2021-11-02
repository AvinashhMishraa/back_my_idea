class Comment < ApplicationRecord
  # searchkick word_middle: [:body]
  # searchkick
  belongs_to :user
  belongs_to :commentable, polymorphic: true


  # # for searchkick
  # def search_data
  #   {
  #     body: body
  #   }
  # end


end
