
// ==================================================
// MODELS     =======================================
// ==================================================

var Quote = Backbone.Model.extend({
	defaults: {
		quote: '',
		context: '',
		source: '',
		theme: ''
	}
});

var Quotes = Backbone.Collection.extend({
	url: 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json'
});

var quotes = new Quotes();

// ==================================================
// VIEWS      =======================================
// ==================================================

var QuoteView = Backbone.View.extend({
	model: new Quote(),
	tagName: 'tr',
	initialize: function(){
		console.log("quote view initialize");
		this.template = _.template($('.quotes-list-template').html());
	},
	render: function(){
		console.log("quote view render");
		this.$el.html(this.template( this.model.toJSON()));
		return this;
	}
});

var QuotesView = Backbone.View.extend({
	model: quotes,
	el: $('.quotes-list'),
	initialize: function(){
		var self = this;
		console.log("quotesview initialize");
		this.model.fetch({
			success: function(response){
				_.each(response.toJSON(), function(item){
					console.log("successfully got quote = " + item.quote);
				})
				self.render();
			},
			error: function(){
				console.log("failed to get quotes");
			}
		});
	},
	render: function(){
		console.log("quotesview render");
		var self = this;
		this.$el.html('');
		_.each(this.model.toArray(), function(quote){
			self.$el.append((new QuoteView({model: quote})).render().$el);
		});
		return this;
	}
});

var quotesView = new QuotesView();

// ==================================================
// JAVASCRIPT      ==================================
// ==================================================


$(document).ready(function(){


});