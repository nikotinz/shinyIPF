// Toggle theme function
function toggleTheme() {
	const isDark = document.getElementById('theme_switch').checked;
	document.body.classList.toggle('dark', isDark);
	
	// Save preference
	localStorage.setItem('darkMode', isDark);
	
	// Notify Shiny
	if (window.Shiny) {
		Shiny.setInputValue('theme_switch', isDark);
	}
}

// Initialize theme on load
document.addEventListener('DOMContentLoaded', function() {
	const darkMode = localStorage.getItem('darkMode') === 'true';
	document.getElementById('theme_switch').checked = darkMode;
	toggleTheme();
});