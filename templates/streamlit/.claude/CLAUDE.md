# Streamlit App

This is a Streamlit application for data visualization and interactive apps.

## Code Style
- Use Black for formatting
- Use Ruff for linting
- Type hints encouraged

## Project Structure
```
app.py         # Main Streamlit application
pages/         # Multi-page app pages (optional)
utils/         # Utility functions
data/          # Data files (gitignored if sensitive)
```

## Running the App
- `streamlit run app.py` - Start the app
- App will be available at http://localhost:8501

## Streamlit Conventions
- Use `st.` prefix for all Streamlit functions
- Cache expensive computations with `@st.cache_data`
- Use `st.session_state` for state management
- Organize layout with `st.columns()` and `st.container()`

## Common Patterns
```python
import streamlit as st

st.set_page_config(page_title="My App", layout="wide")

@st.cache_data
def load_data():
    # Load and cache data
    pass
```
