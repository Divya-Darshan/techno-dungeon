import re

def extract_video_id(url):
    match = re.search(r"(?:v=|youtu\.be/)([A-Za-z0-9_-]+)", url)
    return match.group(1) if match else None


input_file = "links.txt"
output_file = "Tutorials.md"

with open(input_file, "r") as f:
    links = [line.strip() for line in f if line.strip()]

markdown_lines = []

for link in links:
    video_id = extract_video_id(link)
    if video_id:
        markdown = f"""
<div align="center" style="margin-bottom:30px;">

<div style="border-radius:12px; overflow:hidden; display:inline-block; box-shadow:0 4px 12px rgba(0,0,0,0.2);">

<a href="{link}">
<img src="https://img.youtube.com/vi/{video_id}/maxresdefault.jpg" width="480"/>
</a>

</div>

</div>
"""
        markdown_lines.append(markdown.strip())

with open(output_file, "w") as f:
    f.write("\n\n".join(markdown_lines))

print("Tutorials.md created successfully!")