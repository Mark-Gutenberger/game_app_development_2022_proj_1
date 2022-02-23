module.exports = {
	root: true,
	extends: ['eslint:recommended', 'prettier'],
	parserOptions: {
		ecmaVersion: 2020,
		parser: 'babel-eslint',
		ecmaFeatures: {
			jsx: true,
		},
	},
	env: {
		browser: true,
		node: true,
		'react-native/react-native': true,
	},
	plugins: ['prettier', 'react', 'react-native'],
	globals: {},
	rules: {
		'prettier/prettier': 'warn',
		'class-methods-use-this': 'off',
		'no-param-reassign': 'off',
		camelcase: 'off',
		'no-unused-vars': 'off',
	},
};
