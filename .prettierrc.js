/*
 * SPDX - License - Identifier: MIT
 * Author: Mark Gutenberger <mark-gutenberger@outlook.com>
 * .prettierrc.js (c) 2022
 * Desc: prettier config file
 * Created:  2022-02-25T14:24:49.313Z
 * Modified: 2022-03-06T04:49:54.106Z
 */
module.exports = {
	$schema: 'http://json.schemastore.org/prettierrc',
	arrowParens: 'always',
	bracketSameLine: false,
	bracketSpacing: true,
	embeddedLanguageFormatting: 'auto',
	endOfLine: 'lf',
	htmlWhitespaceSensitivity: 'css',
	insertPragma: false,
	jsxSingleQuote: true,
	printWidth: 125,
	quoteProps: 'as-needed',
	semi: true,
	singleQuote: true,
	tabWidth: 4,
	trailingComma: 'es5',
	useTabs: true,
	vueIndentScriptAndStyle: false,
	overrides: [
		{
			files: [
				'nuget.config',
				'*.props',
				'*.filters',
				'*.vcxproj',
				'*.targets',
				'*.xaml',
				'packages.config',
				'*.appxmanifest',
			],
			options: {
				parser: 'xml',
			},
		},
		{
			files: ['*.yml', '*.yaml'],
			options: {
				singleQuote: false,
				useTabs: false,
				tabWidth: 2,
			},
		},
		{
			files: ['*.md', '*.html'],
			options: {
				singleQuote: false,
				printWidth: 100,
			},
		},
		{
			files: ['*.svg'],
			options: {
				parser: 'xml',
			},
		},
		{
			files: ['*.ejs'],
			options: {
				parser: 'glimmer',
			},
		},
	],
};