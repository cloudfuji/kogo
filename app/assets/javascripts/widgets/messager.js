(function ($, undefined) {
  var user_form = {
    options: {

    }
  	,_create: function() {
  	  var $ele = this.element
  	      ,self = this
  	      ;
  	      
      $ele.validationEngine('attach', {
        onValidationComplete: $.proxy(self.submit, self)
        ,promptPosition : "topLeft"
        , scroll: false 
      });
      
      $('.delete_user').live('click', function(e){
        e.preventDefault();
        var $this = $(this)
            ,username = $this.parent('li').data('name')
            ;
            
    	  $.ajax({
    	    type: 'POST'
    	    ,url: "/groups/remove.json"
    	    ,data:{
    	      user_id: username
    	    }
    	    ,error : function(jqXHR, text, status){
    	      $ele.validationEngine('showPrompt', jqXHRMessage(jqXHR), 'error', "topLeft", true);
    	    }
    	    ,success : function(data, textStatus, jqXHR){
            self.remove_user($this.parent('li'), function(){
              $ele.validationEngine('showPrompt', jqXHRMessage(jqXHR), 'pass', "topLeft", true);
            });    
    	    }
    	  });            
      });
      
      return false;	    
  	}
  	
  	,_init: function(){
	    return;
  	}
  	
  	,destory: function() {
  		$.widget.prototype.apply(this, arguments); // default destroy
  		// this is where you would want to undo anything you do on init to reset the page to before the plugin was initialized.
  	}
  	
  	,increment_count: function(){
  	  
  	}
  	
  	,submit: function(e){
  	  var self = this;
  	  var $self = $(e[0]);
	  $self.disable();
  	  $.ajax({
  	    type: 'POST'
  	    ,url: "/groups/add.json"
  	    ,data: {
  	      user_id: $self.find('input:first').val()
  	    }
  	    ,error : function(jqXHR, text, status){
  	      $self.validationEngine('showPrompt', JSON.parse(jqXHR.responseText).message, 'error', "topLeft", true);
	      $self.enable();
  	    }
  	    ,success : function(data, textStatus, jqXHR){
  	      var message = (data.message) ? data.message : jqXHRMessage(jqXHR)
  	          ,user_data = {username : message.match(/\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/gi)[0], css_active_class : null}
  	          ;

  	      $self.validationEngine('showPrompt', message, 
				     (data.data.loading) ?'load': 'pass', "topLeft", true);

  	      if(data.data.loading){ //if the record is pending non-active
		  user_data['css_active_class'] = 'not_active';
		  self.add_user(user_data);
	      }

	      $self.enable();
  	    }
  	  });
  	  return false;
  	}
  	
  	,add_user: function(user_data){
  	  var template = $('#user_profile_tmpl').html()
  	      ,$new_ele = $.tmpl(template, user_data)
  	      ,$list = $('.user_list:first')
  	      ,$counter = $('.user_counter:first')
  	      ,count = parseInt($counter.text(), 10) + 1
  	      ;
  	  
  	  $list.append($new_ele);
  	  $counter.text(count);
  	}
  	
  	,remove_user: function($li, cb){
  	  var $counter = $('.user_counter:first')
      ,count = parseInt($counter.text(), 10) - 1
      ;
      $li.fadeOut('slow', function(){
        if(typeof cb == 'function'){
          cb();
          $counter.text(count);
        }
      });
  	}
	
  };

  $.widget('bushido.user_form', user_form);

}(jQuery));
