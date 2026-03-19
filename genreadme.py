import re

def extract_video_id(url):
    # Handles both youtu.be and youtube.com links
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
        markdown = f"[![Watch](https://img.youtube.com/vi/{video_id}/0.jpg)]({link})"
        markdown_lines.append(markdown)

# Write to README file
with open(output_file, "w") as f:
    f.write("\n\n".join(markdown_lines))

print("README_generated.md created successfully!")