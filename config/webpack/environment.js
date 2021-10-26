const { environment } = require('@rails/webpacker')

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

module.exports = environment
