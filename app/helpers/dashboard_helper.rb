module DashboardHelper

  def get_source_vise_content(report)
    # block for twitter/rubygem/github
    content = ""
    report.each do |source, result|
      content += content_tag(:h1, source)
      result_content = "Not User Found!!!"
      if result.present?
        result_content = ""
        result.each do |key, value|
          if key == "user" and value.present?
            result_content += content_tag(:div, user_content_li(source, value), :class => "user_info")
            result_content += content_tag(:div, "", :class => "clear")
          else
            result_content += content_tag(:h2, key, :class => "contain")
            result_content += content_tag(:div, "", :class => "clear")
            result_content += content_content_li(key, value)
          end
        end
      end
      content += content_tag(:div, result_content.html_safe, :class => "source_content #{source}_content")
      content += content_tag(:div, "", :class => "clear")
    end
    content.html_safe
  end
  
  def content_content_li(type, data)
    # Create source vise list
    content = ""
    content += "<div class='contain_list'>"
    if data.present?
      ul_content = ""
      data.each do |item|
        li_content = ""
        if type == "tweets"
          li_content = item[:tweet]
        elsif type == "repositories"
          li_content = link_to item[:name], item[:url], :title => item[:name] rescue ""
          li_content += content_tag(:div, "", :class => "clear")
          li_content += content_tag(:p, item[:description])
          li_content += content_tag(:div, "", :class => "clear")
          li_content += content_tag(:small, "Created At : #{item[:created_at]}") rescue ""
        elsif type == "gems"
          li_content = link_to item[:name], item[:url], :title => item[:name] rescue ""
          li_content += content_tag(:div, "", :class => "clear")
          li_content += content_tag(:p, item[:info])
          li_content += content_tag(:div, "", :class => "clear")
          li_content += content_tag(:small, "Version: #{item[:version]}") rescue ""
        end
        ul_content += content_tag(:li, li_content.html_safe)
      end
      content += content_tag(:ul, ul_content.html_safe)
    else
      content += "No Records Found!!!"
    end
    content += "</div>"
    content_tag(:div, content.html_safe, :class => "user-item")
    content.html_safe
  end
  
  def user_content_li(type, data)
    # Create User Block
    content = ""
    content += "<div class='social-content'>"
    content += "<div class='item-header'>"
    user_name = data[:handle] rescue ""
    if type == "twitter"
      user_name = "@<b>#{data[:handle]}</b>".html_safe
      content += "<a href='https://twitter.com/#{data[:handle]}'>"
      content += image_tag("https://twitter.com/#{data[:handle]}/profile_image")
    elsif type == "rubygem"
      content += "<a href='https://rubygems.org/profiles/#{data[:handle]}'>"
      content += image_tag("https://secure.gravatar.com/avatar/2d78cb92fbf0a10a89155453d30ad414.png")
    elsif type == "github"
      content += "<a href='https://github.com/#{data[:handle]}'>"
      content += image_tag("#{data[:image_url]}")
    end
    content += "<span class='account'>"
    content += content_tag(:strong, user_name)
    content += "</span></a></div>"
    content += content_tag(:p, data[:description], :class => "description") rescue ""
    content += "</div>"
    if data[:joining_date].present?
      content += content_tag(:strong, "Joining Date: " + data[:joining_date].to_s, :class => "join") 
    end
    content_tag(:div, content.html_safe, :class => "user-item")
    content.html_safe
  end
  
end
