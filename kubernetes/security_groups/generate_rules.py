# Generate OpenStack rules for trusted host
# All rules to be generated will use TCP protocol
import json


def load_host_file(path: str = "./hosts.json"):
    with open(file=path, encoding='utf-8', mode='r') as hf:
        content = json.load(fp=hf)
    return content


def create_rule(remote_ip: str, dst_port: str, description: str, security_group: str) -> str:
    command = (
        f"openstack security group rule create ",
        f"--remote-ip {remote_ip} ",
        f"--dst-port {dst_port} ",
        f"--protocol tcp ",
        f"--description '{description}' ",
        f"--ingress ",
        f"{security_group} ",
    )

    return "".join(command)


def generate_rules(host_dict: dict):
    rules: dict = {}
    security_group: str = host_dict["security_group"]
    ports: list = host_dict["ports"]
    trusted_sources: list = host_dict["trusted_sources"]

    for ts in trusted_sources:
        host: str = ts["host"]
        ips: list = ts["ips"]
        for ip in ips:
            # Create one rule per each port
            for p in ports:
                dst_port: str = p['dst_port']
                description: str = p['description']
                # Create the rule and save under a host key
                new_rule = create_rule(
                    remote_ip=ip,
                    dst_port=dst_port,
                    description=description,
                    security_group=security_group
                )
                # Append it
                rules_host = rules.get(host)
                if rules_host is None:
                    rules_host = []

                rules_host.append(new_rule)
                rules[host] = rules_host

    return rules


def generate_file(rules_dict: dict, path: str = "rules.sh"):
    shebang: str = "#/bin/bash"
    with open(file=path, encoding='utf-8', mode='w') as rf:
        rf.write(shebang)
        rf.write("\n\n")
        for host, rules in rules_dict.items():
            rf.write(f"# Rules for Trusted host: {host}")
            rf.write("\n")
            for r in rules:
                rf.write(r)
                rf.write("\n")
            rf.write("\n")


def main():
    trusted_sources: dict = load_host_file()
    rules: dict = generate_rules(host_dict=trusted_sources)
    generate_file(rules_dict=rules)


if __name__ == "__main__":
    main()
