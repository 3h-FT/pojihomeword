const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/views/kaminari/**/*.erb'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],

  safelist: [
    'fixed',
    'bottom-0',
    'w-full',
    'z-50',
    'bg-pink-50',
    'shadow-inner',
    'border-t',
    'border-pink-200',
    'text-xs',
    'text-pink-700',
    'hover:text-pink-800',
    'bg-pink-200',
    'text-yellow-600',
    'hover:text-yellow-800',
    'bg-yellow-200',
    'text-red-600',
    'hover:text-red-800',
    'bg-red-200'
  ]
}
