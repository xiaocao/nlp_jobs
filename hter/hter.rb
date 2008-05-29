require 'xmas'
require 'open-uri'
require 'yaml'
require 'fileutils'

class HTERJob < Xmas::JSJob
  USET = "hter3"
  
  class << self
    #okay, so this is the form that they'll be filling in.
    def form_json
      [
       ['translation', ''],
       #['translation2', '<%= @hyp_n %>'],
       #['translation3', '<%= @hyp_r %>'],
       ['comment', '']]
    end
     
    def form_labels
      { :translation => {:required => true, :label => "Corrected Minimum-Edit Translation"}, :validation=>["\\S\\S\\S", "Please enter a full corrected translation."],
      }
      #{ :translation => {:required => true, :label => "Corrected Translation 2 with minimum edits"}}
      #{ :translation => {:required => true, :label => "Corrected Translation 3 with minimum edits"}}
    end
=begin    
    def questions
      problem = "Product name: \"<%= unit.data['Product_Name'] %>\"<br/>
                 Brand name: \"<%= unit.data['Brand_Name'] %>\"<br/>
                 Part number: \"<%= unit.data['Part_#'] %>\"<br/>
      Try <a href='http://google.com/search?q=<%= CGI.escape(unit.data['Product_Name']+' '+unit.data['Brand_Name'])  %>' target='_blank'>searching</a> google.
      "
      #hidden_field_names = ["event_id"]

      instructions = "Given the Product name, Brand name, and potentially a Part number for a spa, search the web and complete the form below with as many attributes as possible.  If you can't fill out every field, that is okay.  If you can't find the product at all, check the \"Unable to find?\" box (<i>If other turkers are able to find the product and provide accurate data, you will not be credited for the hit</i>).  The manufacturers website is usually a good source of information, but often times information will have to be gathered from other sources."

      Xmas::JSAwesomeQuestionGenerator.new(form, problem, {:styles => styles, :legend => legend, :instructions => instructions})
    end
=end
    def instructions
    <<-YO
      <p>
      In each question you will be given two sentences:  the <b>Human Translation</b> of a 
      foreign-language sentence, and an automatic <b>Machine Translation</b> of that same sentence.
      <p>
      We want you to create a <b>Corrected Translation</b> that makes the Machine Translation understandable, with roughly the same <b>meaning</b> as 
      the Human Translation, but with <b>as few edits as possible</b> to the original Machine Translation. In particular, we want the closest
      understandable translation with the fewest word insertions, deletions, substitions, and shifts possible.<p>
      Here are some examples:
<hr>
      <h3>Example 1</h3>
      <b>Human Translation:</b>
      <ul><li>He added that the actual date of arrival would be agreed upon with the Office of the Prosecutor General.
      </ul>
      
      <b>Machine Translation:</b>
      <ul><li>He added that the actual date to be agreed upon with the Office of the prosecutor.
      </ul>
      
      <b>Corrected Minimum-Edit Translation:</b>
      <ul><li>He added that the actual arrival date was to be agreed upon with the Office of the prosecutor General.</ul>
<hr>
    <h3>Example 2</h3>
      <b>Human Translation:</b>
      <ul><li>Judge Bulbul is expected to decide, in the light of Gemayel's testimony, whether he will listen to other 
      family members' testimonies in the same dossier.
      </ul>
      
      <b>Machine Translation:</b>
      <ul><li>The judge is expected to decide, in the light of the beautiful, whether he will file in to from others of
      the family.
      </ul>
      
      <b>Correct Minimum-Edit Translation:</b>
      <ul><li>The judge is expected to decide, in the light of the testimony, whether he will file in the same dossier 
      testimony from others of the family.
      </ul>
<hr>      
<h3>Example 3</h3>
      <b>Human Translation:</b>
      <ul>The Education Directorate for Holy Mecca has finished preparing a new computer program to monitor disadvantaged and
      deprived students in schools supervised by the directorate, of which there are over 500.<li>
      </ul>
      
      <b>Machine Translation:</b>
      <ul><li>Ended the General Administration for Education in the holy capital, the preparation of the new program to 
      follow up the needy students and the poor in schools, supervised by the administration number more than 500 schools.
      </ul>
      
      <b>Corrected Minimum-Edit Translation:</b>
      <ul><li>the General Administration for Education in the holy capital, Ended the preparation of the new program 
      to follow up the needy students and the poor in schools, supervised by the administration whose schools number 
      more than 500.
      </ul>
      <hr>
      
      You should start by copying and pasting the Machine Translation to the answer box, and then make edits to that string.
          YO
    end
    
    def styles
      %{
        ul {margin-top: 0}
        .translation { font-size: 120%; width: 90% }
      }
    end
    
    def problem
      <<-TABLE
      <b>Human Translation:</b><ul><li><%= @ref %></ul>
      <b>Machine Translation:</b><ul><li class='hyp'><%= @hyp %></ul>
      TABLE
    end
    
    def js
      <<-JS
      window.addEvent('load', function() {
        $$('.wrapper').each(function(elt) {
          var hyp = elt.getElement('.hyp')
          if (hyp == null) return
          var text = hyp.innerHTML.replace(/^\s+|\s+$/,'')
          elt.getElement('input.translation').value = text
        })
      })
      JS
    end
    
    def units_per_hit
      5
    end
    
    def title
      "Create an understandable sentence with the fewest number of changes from an automatic translation."
    end
    
    def description
      "This version pays several times better than the previously posted one.  Thanks for the angry feedback, y'all :)"
    end
    
    def judgements_per_unit
      10
    end
    
    def reward_cents
      3
    end
    
    
    def keywords
      "translation, correction, editing, minimum edits"
    end
  
  end
end
