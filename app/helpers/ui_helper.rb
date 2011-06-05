module UiHelper

  def ui(*args, &block)
    component = []
    if args.length == 1 && args.first.is_a?(Hash) && args.first.length == 1
      component << args.first.keys.first
    else 
      while args.first.is_a? Symbol
        component << args.shift
      end
    end
    component = "ui_#{component.join '_'}"
    xrb = ui_capture(*args, &block)
    @components << xrb if @components

    self.send(component, xrb)
  end

  def ui_image_block(xrb)
    image = xrb.components.shift
    group = xrb.components.shift

    title = group.components.shift
    contents = group.components.shift
    
    ui_output do <<-HTML
      <div class="image-block">
        <div class="image">#{image}</div>
        <div class="content">
          <div class="title">#{title}</div>
          #{contents}
        </div>
      </div>
      <div class="clear"></div>
    HTML
    end
  end

  def ui_link(xrb)
    xrb.attributes[:href] = xrb.attributes[:link] if xrb.attributes[:link]

    xrb.content = ui_output do
      content_tag(:a, xrb.inner_content, xrb.attributes)
    end
  end

  def ui_group(xrb)
    xrb.content = ui_output do
      xrb.inner_content
    end
  end

  # helper
  def ui_output
    value = yield

    value.html_safe
  end

  def ui_capture(*args, &block)
    xrb = ::XRB::Element.new
    xrb.attributes = args.extract_options!

    if block
      @components, old_components = [], @components
      xrb.inner_content = capture(&block)
      xrb.components = @components
      @components = old_components
    else
      xrb.inner_content = args.first || ''
    end

    if xrb.inner_content.is_a?(String) && ! xrb.inner_content.html_safe?
      xrb.inner_content = xrb.inner_content.html_safe
    end

    xrb
  end

end
