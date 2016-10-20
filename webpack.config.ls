require! {
  'path'
  'browser-sync-webpack-plugin': BrowserSyncPlugin
}

devMode = process.env.NODE_ENV isnt \production

module.exports =
  entry:
    index:
      if devMode
        'webpack-dev-server/client?http://localhost:8081'
        'webpack/hot/only-dev-server'
        './src/index.ls'
      else
        ['./src/index.ls']

  devtool: if devMode then \eval

  resolve:
    extensions: ['', '.js', '.ls']
    fallback:
      [ path.join(__dirname, \node_modules) ]
    alias:
      '$ns': path.join __dirname, 'src/namespaces'
      '$engino': path.join __dirname, './'

  plugins:
    * new BrowserSyncPlugin do
        {
          host:  'localhost'
          port:  8081
          proxy: 'http://localhost:8081/'
        }
        {
          reload: no
        }
    ...

  output:
    path: path.join __dirname, './dist'
    filename: 'index.dist.js'
    publicPath: '/dist/'  # shows the path from .html file till the .js files for script tag

  resolveLoader:
    root:
      path.join __dirname, \node_modules

  module:
    loaders:
      * loader: if devMode then \react-hot!livescript else \livescript
        test: /\.ls$/

      * loader: \json
        test: /\.json$/

      * loader: \style
        test: /\.styl$/

      * loader: "css?module" + if devMode then '&sourceMap&localIdentName=[name]_[local]_[hash:base64:3]' else ''
        test: /\.styl$/

      * loader: \stylus
        test: /\.styl$/

      * loader: 'url-loader'
        test: /\.(woff|otf|ttf|png|gif|jpg)$/

