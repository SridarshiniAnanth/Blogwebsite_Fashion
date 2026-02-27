import os, glob, re, shutil

root_dir = r"c:\Users\SRIDARSHINI A\Desktop\fashion blog\root"
html_files = glob.glob(os.path.join(root_dir, "*.html"))
pattern = re.compile(r'(?:src|href)="([^"]+)"')

all_paths = set()
for html in html_files:
    with open(html, "r", encoding="utf-8") as f:
        matches = pattern.findall(f.read())
        all_paths.update(matches)

moved_count = 0
for path in all_paths:
    if path.startswith("http") or path.startswith("mailto:") or not path.strip():
        continue
    
    basename = os.path.basename(path)
    if os.path.dirname(path):
        source_file = os.path.join(root_dir, basename)
        target_file = os.path.join(root_dir, path)
        target_dir = os.path.dirname(target_file)
        
        if os.path.exists(source_file) and not os.path.exists(target_file):
            print(f"Moving {basename} -> {path}")
            os.makedirs(target_dir, exist_ok=True)
            shutil.move(source_file, target_file)
            moved_count += 1

print(f"Total files moved: {moved_count}")
