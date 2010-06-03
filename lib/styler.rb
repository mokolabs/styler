module Styler

  def stylesheets(options='')

    # Applicaton defaults
    stylesheets = ["application"]

    # Additional sheets (if requested)
    if options.respond_to?(:keys) && options[:include]
      if options[:include].respond_to?(:entries) # Array?
        options[:include].each do |stylesheet|
          stylesheets << stylesheet
        end
      else
        stylesheets << options[:include]        # String
      end
    end

    # Controller/action sheets
    stylesheets << "#{controller.controller_name}"
    stylesheets << "#{controller.controller_name}_#{controller.action_name}"
    stylesheets << "#{controller.controller_name}/#{controller.action_name}"

    # iPhone
    stylesheets << "iphone"

    # IE6 / IE7 / IE8
    stylesheets << "ie8"
    stylesheets << "ie7"
    stylesheets << "ie6"

    # Add links to header
    stylesheets.collect! do |name|
      name = "#{options[:path]}/#{name}" unless options[:path].nil?
      if File.exist?(File.join(ActionView::Helpers::AssetTagHelper.const_get("STYLESHEETS_DIR"), "#{name}.css"))
        case name
        when "ie8"
          "<!--[if IE 8]>" + stylesheet_link_tag(name) + "<![endif]-->"
        when "ie7"
          "<!--[if IE 7]>" + stylesheet_link_tag(name) + "<![endif]-->"
        when "ie6"
          "<!--[if IE 6]>" + stylesheet_link_tag(name) + "<![endif]-->"
        when "iphone"
          stylesheet_link_tag(name).gsub(/screen/,"only screen and (max-device-width: 480px)")
        else
          stylesheet_link_tag(name)
        end
      end
    end
    stylesheets.compact.join("\n")
  end

end

