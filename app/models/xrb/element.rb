module XRB
  class Element
    attr_accessor :content, :inner_content, :attributes, :components

    def to_s
      content
    end
  end
end
