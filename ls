document.addEventListener('DOMContentLoaded', () => {
    const root = document.documentElement;
    const themeToggle = document.getElementById('theme-toggle');

    // --- 1. THEME TOGGLE LOGIC ---
    const updateThemeIcon = (isDark) => {
        if (!themeToggle) return;
        // If dark mode is active, show sun (to switch to light)
        // If light mode is active, show moon (to switch to dark)
        themeToggle.textContent = isDark ? '☀️' : '🌙';
    };

    const savedTheme = localStorage.getItem('theme');
    let isDark;

    if (savedTheme === 'dark' || savedTheme === 'light') {
        // Use the user's saved preference
        isDark = savedTheme === 'dark';
    } else {
        // No saved preference:
        // 1) Respect whatever the anti-flash script already did
        // 2) Otherwise, fall back to system preference
        const systemPrefersDark =
            window.matchMedia &&
            window.matchMedia('(prefers-color-scheme: dark)').matches;

        isDark = root.classList.contains('dark-theme') || systemPrefersDark;

        // Persist this initial choice so future loads are stable
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    }

    // Ensure the body class matches our final decision
    root.classList.toggle('dark-theme', isDark);

    // Update the icon immediately
    updateThemeIcon(isDark);

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            // Toggle the class
            const currentIsDark = root.classList.toggle('dark-theme');

            // Save to local storage
            localStorage.setItem('theme', currentIsDark ? 'dark' : 'light');

            // Update the icon
            updateThemeIcon(currentIsDark);
        });
    }

    // --- 3. SCROLL FADE-IN LOGIC ---
    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                obs.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.scroll-fade-in').forEach(el => observer.observe(el));
    
    // --- 4. ACTIVE LINK LOGIC ---
    const pathSegments = window.location.pathname.split('/');
    let currentPage = pathSegments.pop() || 'index.html';
    if (currentPage === '') currentPage = pathSegments.pop() || 'index.html';

    document.querySelectorAll('nav a').forEach(link => {
        link.classList.remove('active');
        const linkPage = link.getAttribute('href').split('/').pop();
        if (linkPage === currentPage) {
            link.classList.add('active');
        } 
    });

    const logoLink = document.querySelector('.logo a');
    if (logoLink) {
        logoLink.classList.remove('active');
        if (currentPage === 'index.html') {
            logoLink.classList.add('active');
        }
    }
});
