module ApplicationHelper

  # display messages to user

  def flashed
    if flash[:errors]
      class_ = 'errors'
      @messages = flash[:errors]
    elsif flash[:success]
      class_ = 'success'
      @messages = flash[:success]
    end

    if @messages
      html = <<-HTML
        <div class="#{class_}">
          <ul>
      HTML

      @messages.each do |msg|
        html << "<li>#{msg}</li>"
      end

      html << <<-HTML
          </ul>
        </div>
      HTML
      html.html_safe
    else
      nil
    end
  end
  
  # routing helpers

  def delete_path(object_)
    self.send("delete_#{object_.class_name.underscore}_path", object_.id)
  end

  def destroy_path(object_)
    self.send("destroy_#{object_.class_name.underscore}_path", object_.id)
  end

  def edit_path(object_)
    self.send("edit_#{object_.class_name.underscore}_path", object_)
  end

  def index_path(object_)
    self.send("#{object_.class_name.tableize}_path")
  end

  def new_path(group)
    if params[:user_id]
      self.send("new_user_#{group}_path", params[:user_id])
    else
      self.send("new_#{group}_path")
    end
  end

  # rendering helpers

  def display_associations(object_)
    assocs = %w(authors books genres)
    assocs.delete_if do |assoc|
      assoc == object_.class_name.tableize
    end

    html = '<h3>'

    assocs.each do |assoc|
      html << "#{assoc.capitalize}</h3><ul>"
      found = object_.send(assoc)
      unless found.empty?
        found.each do |found_item|
          html << <<-HTML
            <li>
              #{self.send('link_to', found_item.name, found_item)}
            </li>
          HTML
        end

        html << '</ul>'
      else
        html << 'None found</ul>'
      end
    end

    html.html_safe
  end

  def display_attributes(object_)
    attrs = object_.attributes
    attrs.delete_if do |key, val|
      %w(created_at updated_at id).include? (key) or val == object_.name
    end

    attrs.collect do |key, val|
      <<-HTML
        <h3>#{key}</h3>
        <p>#{val || 'Not provided'}</p>
      HTML
    end.join('<br>').html_safe
  end

  def favorite(object_)
    user = User.find(session[:user_id])
    user_favorites = user.send(object_.class_name.tableize)

    favorite_button(object_, user, user_favorites)
  end

  def index(objects)
    if objects.empty?
      html = '<h1>None found in database</h1>'
    elsif !objects[0].is_a?(User)
      group = objects[0].class_name.pluralize
      user = User.find(session[:user_id])
      user_favorites = user.send(group.tableize)

      html = "<h2>#{group}</h2>"

      objects.each do |object_|
        html << "<h3>#{self.send('link_to', object_.name, object_)}</h3>"
        html << favorite_button(object_, user, user_favorites)
      end
    else
      html = '<ul>'

      objects.each do |user|
        html << "<li>#{self.send('link_to', user.name, user)}</li>"
      end

      html << '</ul>'
    end

    html.html_safe
  end

  def logout_button
    case request.path
    when self.send('root_path')
      nil
    when self.send('signup_path')
      nil
    when self.send('login_path')
      nil
    else
      if request.path == self.send('logout_path')
        method = :post
        cancel_path = self.send('user_path', User.find(session[:user_id]))
      else
        method = :get
      end
      root = self.send('root_path')
      logout_path = self.send('logout_path')
      erb = "#{self.send('button_to', 'Log Out', logout_path, method: method)}"
      if request.path == self.send('logout_path')
        erb << "#{self.send('link_to', 'Cancel', cancel_path)}"
      end

      erb.html_safe
    end
  end

  def notes(object_)
    fav_class = "Favorite#{object_.class_name}".constantize
    search_key = "#{object_.class_name.underscore}_id".to_sym
    user_favorite = fav_class.where(:user_id => session[:user_id], search_key => object_.id).first

    if user_favorite
      html = <<-HTML
        <fieldset>
          <legend>My Notes</legend>
          #{user_favorite.notes ? user_favorite.notes : 'N/A'}
        </fieldset>
      HTML

      html.html_safe
    end
  end

  def profile
    case request.path
    when self.send('root_path')
      nil
    when self.send('signup_path')
      nil
    when self.send('login_path')
      nil
    else
      user = User.find_by(id: session[:user_id])
      if session[:user_id] && request.path == self.send('user_path', user)
        nil
      elsif session[:user_id]
        self.send('link_to', 'My Profile', user).html_safe
      else
        nil
      end
    end
  end

  def render_popular(popular)
    html = '<ul>'
    popular.each do |object_|
      html << "<li>#{object_.name} (#{pluralize(popular.count[object_.name], 'favorite')})</li>"
    end
    html << '</ul>'

    html.html_safe
  end

  # processing methods

  private

    def favorite_button(object_, user, user_favorites)
      if user_favorites.include?(object_)
        html = self.send('button_to', 'Unfavorite', "/users/#{user.id}/unfavorite/#{object_.class_name}/#{object_.id}", class: 'unfavorite_button')
        if params[:user_id] && params[:user_id].to_i == session[:user_id]
          fav_class = "Favorite#{object_.class_name}".constantize
          search_key = object_.class_name.underscore.to_sym
          fav = fav_class.where(:user_id => user.id, search_key => object_.id).first
          inner_html = <<-HTML
            <fieldset>
              <legend>My Notes</legend>
              <p>#{fav.notes ? fav.notes : 'N/A'}</p>
            </fieldset>
          HTML

          html << inner_html.html_safe
        end
      else
        html = self.send('button_to', 'Favorite', "/users/#{user.id}/favorite/#{object_.class_name}/#{object_.id}", class: 'favorite_button')
      end

      html.html_safe
    end

end
