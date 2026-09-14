# N5 - Agentic Cloud Project Generator
Baseado em: builder.aws.com/content/3FHEWNRlcZDqe1QJqNe8wiZHWyj/

Arquitetura:
Frontend (S3) -> API GW HTTP -> Lambda (Strands Agent + tools.py) -> Bedrock Claude

Tools:
- suggest_projects
- get_build_plan

Deploy:
cd infrastructure && cdk deploy
