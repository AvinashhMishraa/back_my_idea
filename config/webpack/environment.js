const { environment } = require('@rails/webpacker')
const jquery = require('./plugins/jquery')

const config = environment.toWebpackConfig();

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

config.resolve.alias = {
	jquery: 'jquery/src/jquery'
}

environment.plugins.prepend('jquery', jquery)
module.exports = environment
